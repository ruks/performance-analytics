#!/bin/bash
# Copyright 2017 WSO2 Inc. (http://wso2.org)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------------
# Create a summary report from JMeter results
# ----------------------------------------------------------------------------

get_gc_headers() {
    echo -ne ",$1 GC Throughput (%),$1 Footprint (M),$1 Average of Footprint After Full GC (M)"
    echo -ne ",$1 Standard Deviation of Footprint After Full GC (M)"
}

get_loadavg_headers() {
    echo -ne ",$1 Load Average - Last 1 minute,$1 Load Average - Last 5 minutes,$1 Load Average - Last 15 minutes"
}

get_event_error_headers() {
    echo -ne ",APIM $1 Dropped events,APIM $2 Dropped events,APIM $3 Dropped events,APIM $4 Dropped events,APIM $5 Dropped events"
}

write_column() {
    statisticsTableData=$1
    index=$2
    echo -n "," >> $filename
    echo -n "$(echo $statisticsTableData | jq -r ".overall | .data[$index]")" >> $filename
}

get_value_from_gc_summary() {
    echo $(grep -m 1 $2\; $1 | sed -r 's/.*\;(.*)\;.*/\1/' | sed 's/,//g')
}

write_gc_summary_details() {
    gc_log_file=$user_dir/$1_gc.log
    gc_summary_file=/tmp/gc.txt
    echo "Reading $gc_log_file"
    java -Xms128m -Xmx128m -jar $gcviewer_path $gc_log_file $gc_summary_file -t SUMMARY &> /dev/null
    echo -n ",$(get_value_from_gc_summary $gc_summary_file throughput)" >> $filename
    echo -n ",$(get_value_from_gc_summary $gc_summary_file footprint)" >> $filename
    echo -n ",$(get_value_from_gc_summary $gc_summary_file avgfootprintAfterFullGC)" >> $filename
    echo -n ",$(get_value_from_gc_summary $gc_summary_file avgfootprintAfterFullGCσ)" >> $filename
}

write_loadavg_details() {
    loadavg_file=$user_dir/$1_loadavg.txt
    if [[ -f $loadavg_file ]]; then
        echo "Reading $loadavg_file"
        loadavg_values=$(tail -2 $loadavg_file | head -1)
        loadavg_array=($loadavg_values)
        echo -n ",${loadavg_array[3]}" >> $filename
        echo -n ",${loadavg_array[4]}" >> $filename
        echo -n ",${loadavg_array[5]}" >> $filename
    else
        echo -n ",N/A,N/A,N/A" >> $filename
    fi
}

write_event_errors() {
    count=$(cat $user_dir/$1_event_drop.txt)
    echo -n ",$count" >> $filename
}

write_node_details() {
    echo -n "$1" >> $filename
    write_gc_summary_details $1
    write_loadavg_details $1
    echo -ne "\r\n" >> $filename
}

write_gw_details() {
    echo -ne "\r\n" >> $filename
    echo -ne "\r\n" >> $filename

    total=0
    while IFS= read -r line
    do
        id=$(echo "$line" | sed -E 's/(w)*,(.)+//')
        newline=$line
        if [ "$id" == "Label" ]
        then
            newline="$line, Dropped"
        elif [ "$id" == "TOTAL" ]
        then
            newline="$line, $total"
        else
            path=$user_dir/$id"_event_drop.txt"
            cnt=$(cat $path)
            total=$(( $total + $cnt ))
            newline="$line, $cnt"
        fi
        echo -n "$newline" >> $filename
        echo -ne "\r\n" >> $filename
    done < "$input"
}

gcviewer_path=gcviewer-1.36.jar
filename=$1
if [[ -z $filename ]]; then
    filename="summary.csv"
fi
rm -f $filename
user_dir=/home/ubuntu/metrix
input="metrix/AggregateReport.csv"

if [[ ! -f $filename ]]; then
    # Create File and save headers
    echo -n "Instance Name" > $filename
    echo -n $(get_gc_headers "APIM Analytics") >> $filename
    echo -n $(get_loadavg_headers "APIM Analytics") >> $filename
    echo -ne "\r\n" >> $filename
else
    echo "$filename already exists"
    exit 1
fi

write_node_details analytics1
write_node_details analytics2
write_gw_details


echo "Completed. Open $filename"
