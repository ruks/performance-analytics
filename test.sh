#!/bin/bash
declare -i num
#num=0
#ssh -i ssh/apim310.key  ubuntu@apim1.apim.com grep \"events dropped so far\" wso2am-3.1.0/repository/logs/wso2carbon.log | while read -r line ;
#while read -r line ;
#do
#    val=$(echo "$line" | sed -E 's/.*, ([0-9]+)( events dropped so far.).*/\1/')
#    num=$(( $num + $val ))
#done <<<$(grep "events dropped so far" ./summary.log)
#echo $num


command_prefix="ssh -i ssh/apim310.key ubuntu@apim1.apim.com"
num=0
while read -r line ; do
    val=$(echo "$line" | sed -E 's/.*, ([0-9]+)( events dropped so far.).*/\1/')
    if [ "$val" > "$num" ]; then
        num=$val
    fi
#    num=$(( $num + $val ))
done <<<$($command_prefix grep \"events dropped so far\" wso2am-3.1.0/repository/logs/wso2carbon.log)
#echo $num > ana_event_drop.txt
echo "final $num"


#192.168.114.4   db.apim.com
192.168.114.47  client.apim.com
#192.168.114.48  apim1.apim.com
#192.168.114.58  apim2.apim.com
#192.168.114.30  server1.apim.com
#192.168.114.34  server2.apim.com
#192.168.114.59  analytics1.apim.com
#192.168.114.64  analytics2.apim.com
#192.168.114.65  netty.apim.com