#!/bin/bash

echo "users $1"
echo "duration $2"
echo "tps $3"
echo "skipping $4"

netty=netty.apim.com
jmeter1=server1.apim.com
jmeter2=server2.apim.com
apim1=apim1.apim.com
apim2=apim2.apim.com
analytics1=analytics1.apim.com
analytics2=analytics2.apim.com

#write_server_metrics() {
#    server=$1
#    ssh_host=$2
#    pgrep_pattern=$3
#    report_location=/home/ubuntu
#    command_prefix=""
#    if [[ ! -z $ssh_host ]]; then
#        command_prefix="ssh $ssh_host"
#    fi
#    $command_prefix ss -s > ${report_location}/${server}_ss.txt
#    $command_prefix uptime > ${report_location}/${server}_uptime.txt
#    $command_prefix sar -q > ${report_location}/${server}_loadavg.txt
#    $command_prefix sar -A > ${report_location}/${server}_sar.txt
#    $command_prefix top -bn 1 > ${report_location}/${server}_top.txt
#    if [[ ! -z $pgrep_pattern ]]; then
#        $command_prefix ps u -p \`pgrep -f $pgrep_pattern\` > ${report_location}/${server}_ps.txt
#    fi
#}

ssh -i performance-analytics/ssh/apim310.key $jmeter1 "./performance-common/distribution/scripts/jmeter/jmeter-server-start.sh -n server1.apim.com -i /home/ubuntu/"
ssh -i performance-analytics/ssh/apim310.key $jmeter2 "./performance-common/distribution/scripts/jmeter/jmeter-server-start.sh -n server2.apim.com -i /home/ubuntu/"

if [ "$4" != "-s" ]; then
    echo "skip restarting servers"
	ssh -i performance-analytics/ssh/apim310.key $netty "./performance-common/distribution/scripts/netty-service/netty-start.sh"
    ssh -i performance-analytics/ssh/apim310.key $analytics1 "/home/ubuntu/performance-analytics/analytics-start.sh"
    ssh -i performance-analytics/ssh/apim310.key $analytics2 "/home/ubuntu/performance-analytics/analytics-start.sh"
    ssh -i performance-analytics/ssh/apim310.key $apim1 "/home/ubuntu/performance-analytics/apim-start.sh"
    ssh -i performance-analytics/ssh/apim310.key $apim2 "/home/ubuntu/performance-analytics/apim-start.sh"
fi

/home/ubuntu/apache-jmeter-5.2.1/bin/jmeter -n -t analytics.jmx -R tm.apim.com,gw.apim.com -X \
-Gprotocol=https -Ghost=dev.apim.com -Gport=8243 -Ghost2=worker.apim.com -Gport2=8243 -Gpath=/sample/1.0.0/menu -Gresponse_code=200 \
-Gtoken=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Ill6aG1abUl3TkdZMVpXTTBaR1ZrT0dJM1l6aGlaVGRpWXpZM01XSmxPVGxpTVdNeE56TmtZdz09In0.eyJhdWQiOiJodHRwOlwvXC9vcmcud3NvMi5hcGltZ3RcL2dhdGV3YXkiLCJzdWIiOiJhZG1pbkBjYXJib24uc3VwZXIiLCJhcHBsaWNhdGlvbiI6eyJvd25lciI6ImFkbWluIiwidGllclF1b3RhVHlwZSI6InJlcXVlc3RDb3VudCIsInRpZXIiOiJVbmxpbWl0ZWQiLCJuYW1lIjoic2FtcGxlIiwiaWQiOjIsInV1aWQiOm51bGx9LCJzY29wZSI6ImFtX2FwcGxpY2F0aW9uX3Njb3BlIGRlZmF1bHQiLCJpc3MiOiJodHRwczpcL1wvZGV2LmFwaW0uY29tOjk0NDNcL29hdXRoMlwvdG9rZW4iLCJ0aWVySW5mbyI6eyJVbmxpbWl0ZWQiOnsidGllclF1b3RhVHlwZSI6InJlcXVlc3RDb3VudCIsInN0b3BPblF1b3RhUmVhY2giOnRydWUsInNwaWtlQXJyZXN0TGltaXQiOjAsInNwaWtlQXJyZXN0VW5pdCI6bnVsbH19LCJrZXl0eXBlIjoiUFJPRFVDVElPTiIsInN1YnNjcmliZWRBUElzIjpbeyJzdWJzY3JpYmVyVGVuYW50RG9tYWluIjoiY2FyYm9uLnN1cGVyIiwibmFtZSI6InNhbXBsZSIsImNvbnRleHQiOiJcL3NhbXBsZVwvMS4wLjAiLCJwdWJsaXNoZXIiOiJhZG1pbiIsInZlcnNpb24iOiIxLjAuMCIsInN1YnNjcmlwdGlvblRpZXIiOiJVbmxpbWl0ZWQifV0sImNvbnN1bWVyS2V5IjoiX0E2a2h3c01ueTh3dHVPMEFUNlpNQ0ZzVFFnYSIsImV4cCI6MzczMjYxMTY0MCwiaWF0IjoxNTg1MTI3OTkzLCJqdGkiOiIzNTY1MmM4OS1jYjk1LTQ1NzEtOWExMi00ZTFlMWU5ODJhYWIifQ.rVkh3pvN06RY_5k1RQcGFAFBR7BZcS9fEQVZervkcMi7olR0Pp2mKhYMbKLwQuDKBgoHNjMicZcYGNNSr_J5KMQoi0jwstQGIj4al6_94Jz3F3OWinzQiyS4QVztWDAh4e2CWehto8_fM7kFYbdd_uuJFvkYtjtHNP-AVrL2fpuTK5eizO7P9DQEsI4gNPnWrNF806cDRPIAetNkgqHLra_HWXFjOt-OqJ6QrH9Ea3BYDwBr08lzQ_F7NNSTg9ltAWGJ-xQSK9ibsmURQNiFYODOnTNScP0tPD2ZeJX20e7MyECx2xTpSmMFaxkYvDhQWs_KwzNctjYmCarFvNWYCQ \
-Gusers=$1 -Gduration=$2 -Gtps=$3 -l results.jtl -Jserver.rmi.ssl.disable=true

#write_server_metrics jmeter
#write_server_metrics analytics1 $api_ssh_host carbon
#write_server_metrics analytics2 analytics.apim.com carbon

#nohup ./run-performance-test.sh 150 1800 180000 > out 2>&1 &
#nohup ./run-performance-test.sh 150 900 30000 -s> out 2>&1 &