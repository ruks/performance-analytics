#!/bin/bash

echo "users $1"
echo "duration $2"
echo "tps $3"
echo "skipping $4"

summaryFile="summary_"$2"m_"$3"tps.csv"
netty=netty.apim.com
jmeter1=server1.apim.com
jmeter2=server2.apim.com
apim1=apim1.apim.com
apim2=apim2.apim.com
apim3=apim3.apim.com
apim4=apim4.apim.com
apim5=apim5.apim.com
analytics1=analytics1.apim.com
analytics2=analytics2.apim.com

write_server_metrics() {
    server=$1
    ssh_host=$2
    pgrep_pattern=$3
    report_location=metrix
    command_prefix=""
    if [[ ! -z $ssh_host ]]; then
        command_prefix="ssh -i performance-analytics/ssh/apim310.key $ssh_host"
    fi
    $command_prefix ss -s > ${report_location}/${server}_ss.txt
    $command_prefix uptime > ${report_location}/${server}_uptime.txt
    $command_prefix sar -q > ${report_location}/${server}_loadavg.txt
    $command_prefix sar -A > ${report_location}/${server}_sar.txt
    $command_prefix top -bn 1 > ${report_location}/${server}_top.txt

    if [[ ! -z $pgrep_pattern ]]; then
        $command_prefix ps u -p \`pgrep -f $pgrep_pattern\` > ${report_location}/${server}_ps.txt
    fi
}

write_gw_metrics() {
    server=$1
    ssh_host=$2
    report_location=metrix
    command_prefix=""
    if [[ ! -z $ssh_host ]]; then
        command_prefix="ssh -i performance-analytics/ssh/apim310.key $ssh_host"
    fi

    num=0
    while read -r line ; do
        val=$(echo "$line" | sed -E 's/.*, ([0-9]+)( events dropped so far.).*/\1/')
        if [ "$val" > "$num" ]; then
            num=$val
        fi
        #num=$(( $num + $val ))
    done <<<$($command_prefix grep \"events dropped so far\" wso2am-*/repository/logs/wso2carbon.log)
    echo $num > ${report_location}/${server}_event_drop.txt
}

ssh -i performance-analytics/ssh/apim310.key $jmeter1 "./performance-common/distribution/scripts/jmeter/jmeter-server-start.sh -n server1.apim.com -i /home/ubuntu/"
ssh -i performance-analytics/ssh/apim310.key $jmeter2 "./performance-common/distribution/scripts/jmeter/jmeter-server-start.sh -n server2.apim.com -i /home/ubuntu/"

if [ "$4" != "-s" ]; then
    echo "skip restarting servers"
	ssh -i performance-analytics/ssh/apim310.key $netty "./performance-common/distribution/scripts/netty-service/netty-start.sh"
    ssh -i performance-analytics/ssh/apim310.key $analytics1 "/home/ubuntu/performance-analytics/analytics-start.sh"
    echo "############### $analytics1 started"
    ssh -i performance-analytics/ssh/apim310.key $analytics2 "/home/ubuntu/performance-analytics/analytics-start.sh"
    echo "############### $analytics2 started"

    ssh -i performance-analytics/ssh/apim310.key $apim1 "/home/ubuntu/performance-analytics/apim-start.sh 4 $apim1"
    ssh -i performance-analytics/ssh/apim310.key $apim2 "/home/ubuntu/performance-analytics/apim-start.sh 4 $apim2"
    ssh -i performance-analytics/ssh/apim310.key $apim3 "/home/ubuntu/performance-analytics/apim-start.sh 3 $apim3"
    ssh -i performance-analytics/ssh/apim310.key $apim4 "/home/ubuntu/performance-analytics/apim-start.sh 3 $apim4"
    ssh -i performance-analytics/ssh/apim310.key $apim5 "/home/ubuntu/performance-analytics/apim-start.sh 3 $apim5"

    ssh -i performance-analytics/ssh/apim310.key $apim1 "/home/ubuntu/performance-analytics/wait-apim-start.sh $apim1"
    ssh -i performance-analytics/ssh/apim310.key $apim2 "/home/ubuntu/performance-analytics/wait-apim-start.sh $apim2"
    ssh -i performance-analytics/ssh/apim310.key $apim3 "/home/ubuntu/performance-analytics/wait-apim-start.sh $apim3"
    ssh -i performance-analytics/ssh/apim310.key $apim4 "/home/ubuntu/performance-analytics/wait-apim-start.sh $apim4"
    ssh -i performance-analytics/ssh/apim310.key $apim5 "/home/ubuntu/performance-analytics/wait-apim-start.sh $apim5"

    # Wait for another 10 seconds to make sure that the server is ready to accept API requests
    sleep 10
fi

rm -rf metrix
mkdir metrix

user=$(( $1/2 ))
duration=$(( ($2+1) * 60 ))
tpm=$(( ($3/2) * 60 ))

/home/ubuntu/apache-jmeter-3.3/bin/jmeter -n -t performance-analytics/analytics.jmx -R server1.apim.com,server2.apim.com -X \
-Gprotocol=https -Gport1=8243 -Gport2=8243 -Gport3=8243 -Gport4=8243 -Gport5=8243 \
-Ghost1=apim1.apim.com -Ghost2=apim2.apim.com -Ghost3=apim3.apim.com -Ghost4=apim4.apim.com -Ghost5=apim4.apim.com \
-Gpath=/sample/1.0.0/menu -Gresponse_code=200 \
-Gtoken=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IllUVTVNR0poT1RObFptRm1Nakl4TnpCbU9HVmxZbU0wTW1VNVltTmxPVEk1TW1ZMllUTm1aUT09In0.eyJhdWQiOiJodHRwOlwvXC9vcmcud3NvMi5hcGltZ3RcL2dhdGV3YXkiLCJzdWIiOiJhZG1pbkBjYXJib24uc3VwZXIiLCJhcHBsaWNhdGlvbiI6eyJvd25lciI6ImFkbWluIiwidGllclF1b3RhVHlwZSI6InJlcXVlc3RDb3VudCIsInRpZXIiOiJVbmxpbWl0ZWQiLCJuYW1lIjoiand0IiwiaWQiOjIsInV1aWQiOm51bGx9LCJzY29wZSI6ImFtX2FwcGxpY2F0aW9uX3Njb3BlIGRlZmF1bHQiLCJpc3MiOiJodHRwczpcL1wvYXBpbTEuYXBpbS5jb206OTQ0M1wvb2F1dGgyXC90b2tlbiIsInRpZXJJbmZvIjp7IlVubGltaXRlZCI6eyJ0aWVyUXVvdGFUeXBlIjoicmVxdWVzdENvdW50Iiwic3RvcE9uUXVvdGFSZWFjaCI6dHJ1ZSwic3Bpa2VBcnJlc3RMaW1pdCI6MCwic3Bpa2VBcnJlc3RVbml0IjpudWxsfX0sImtleXR5cGUiOiJQUk9EVUNUSU9OIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJjYXJib24uc3VwZXIiLCJuYW1lIjoic2FtcGxlIiwiY29udGV4dCI6Ilwvc2FtcGxlXC8xLjAuMCIsInB1Ymxpc2hlciI6ImFkbWluIiwidmVyc2lvbiI6IjEuMC4wIiwic3Vic2NyaXB0aW9uVGllciI6IlVubGltaXRlZCJ9XSwiY29uc3VtZXJLZXkiOiJqMWlOVUQ3UUlYQWZIeWlIcWxjUkU2UmE1RTRhIiwiZXhwIjozNzMzMTI4NzM5LCJpYXQiOjE1ODU2NDUwOTIsImp0aSI6ImY1YTM0MWZjLWQxMjgtNDk4OC05ZjBiLTFkM2UzNjczMDIyNiJ9.azyydmzr61Gr7aoJsvpXolb7Udt3Wdk09k7gfTcd40ZJkh3ECE77Vs_-HzVBHFiwbWzkub6UUscP8faLkGuQm2yOgL14qEE7hk85xZ5sZ3Z1AJeY6CkEyZ172LfyK6UjA882TTaf_fwDgKEIOE_YtbJkkNKz1nIrvJD1xFXZSykPLpPXT1TVBxv55M2BpkpHLk-m3Xx4ItFzDvXMiXmoz2qsoDoRm7ERs6XizLfzdUQS7XQFb9lm1lKB-lhGdk2AOKEOsOzfGllISmG52n6Zao1d_jdjpn3W6Cgqd1O6ScctJvOWM3pls_WMzdZD4D_H_uWEi9Oz9pSSq5UwSqfeFQ \
-Gusers=$user -Gduration=$duration -Gtps=$tpm -l metrix/results.jtl

#write_server_metrics jmeter
write_server_metrics analytics1 $analytics1 org.wso2.carbon.launcher.Main
write_server_metrics analytics2 $analytics2 org.wso2.carbon.launcher.Main
echo "done write_server_metrics"

write_gw_metrics apim1 $apim1
write_gw_metrics apim2 $apim2
write_gw_metrics apim3 $apim3
write_gw_metrics apim4 $apim4
write_gw_metrics apim5 $apim5
echo "done write_gw_metrics"

scp -i performance-analytics/ssh/apim310.key $apim1:wso2am-*/repository/logs/gc.log metrix/apim1_gc.log
scp -i performance-analytics/ssh/apim310.key $apim2:wso2am-*/repository/logs/gc.log metrix/apim2_gc.log
scp -i performance-analytics/ssh/apim310.key $apim3:wso2am-*/repository/logs/gc.log metrix/apim3_gc.log
scp -i performance-analytics/ssh/apim310.key $apim4:wso2am-*/repository/logs/gc.log metrix/apim4_gc.log
scp -i performance-analytics/ssh/apim310.key $apim5:wso2am-*/repository/logs/gc.log metrix/apim5_gc.log
scp -i performance-analytics/ssh/apim310.key $analytics1:wso2am-analytics-*/wso2/worker/logs/gc.log metrix/analytics1_gc.log
scp -i performance-analytics/ssh/apim310.key $analytics2:wso2am-analytics-*/wso2/worker/logs/gc.log metrix/analytics2_gc.log
echo "ssh gc copied"

java -Xms1g -Xmx4g -jar performance-common/distribution/scripts/jtl-splitter/jtl-splitter-0.4.6-SNAPSHOT.jar -f metrix/results.jtl -t 1
echo "done jtl-splitter"
/home/ubuntu/apache-jmeter-3.3/bin/jmeter -g metrix/results-warmup.jtl -o metrix/dashboard-warmup
echo "done results-warmup"
#/home/ubuntu/apache-jmeter-3.3/bin/jmeter -g metrix/results-measurement.jtl -o metrix/dashboard-measurement
#echo "done results-measurement"
/home/ubuntu/apache-jmeter-3.3/bin/JMeterPluginsCMD.sh --generate-csv metrix/AggregateReport.csv --input-jtl metrix/results-measurement.jtl --plugin-type AggregateReport
echo "done AggregateReport"

./performance-analytics/create-summary-csv.sh $summaryFile

echo "Performance test completed."
#nohup ./run-performance-test.sh 150 1800 180000 > out 2>&1 &
#nohup ./run-performance-test.sh 150 900 30000 -s> out 2>&1 &
#nohup ./performance-analytics/run-performance-test.sh 150 300 6000 > out 2>&1 &
#nohup ./performance-analytics/run-performance-test.sh 150 900 90000 > out 2>&1 &
#./performance-analytics/create-summary-csv.sh gcviewer-1.36.jar