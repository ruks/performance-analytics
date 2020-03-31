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

/home/ubuntu/apache-jmeter-5.2.1/bin/jmeter -n -t analytics.jmx -R server1.apim.com,server2.apim.com -X \
-Gprotocol=https -Ghost=apim1.apim.com -Gport=8243 -Ghost2=apim2.apim.com -Gport2=8243 -Gpath=/sample/1.0.0/menu -Gresponse_code=200 \
-Gtoken=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IllUVTVNR0poT1RObFptRm1Nakl4TnpCbU9HVmxZbU0wTW1VNVltTmxPVEk1TW1ZMllUTm1aUT09In0.eyJhdWQiOiJodHRwOlwvXC9vcmcud3NvMi5hcGltZ3RcL2dhdGV3YXkiLCJzdWIiOiJhZG1pbkBjYXJib24uc3VwZXIiLCJhcHBsaWNhdGlvbiI6eyJvd25lciI6ImFkbWluIiwidGllclF1b3RhVHlwZSI6InJlcXVlc3RDb3VudCIsInRpZXIiOiJVbmxpbWl0ZWQiLCJuYW1lIjoiand0IiwiaWQiOjIsInV1aWQiOm51bGx9LCJzY29wZSI6ImFtX2FwcGxpY2F0aW9uX3Njb3BlIGRlZmF1bHQiLCJpc3MiOiJodHRwczpcL1wvYXBpbTEuYXBpbS5jb206OTQ0M1wvb2F1dGgyXC90b2tlbiIsInRpZXJJbmZvIjp7IlVubGltaXRlZCI6eyJ0aWVyUXVvdGFUeXBlIjoicmVxdWVzdENvdW50Iiwic3RvcE9uUXVvdGFSZWFjaCI6dHJ1ZSwic3Bpa2VBcnJlc3RMaW1pdCI6MCwic3Bpa2VBcnJlc3RVbml0IjpudWxsfX0sImtleXR5cGUiOiJQUk9EVUNUSU9OIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJjYXJib24uc3VwZXIiLCJuYW1lIjoic2FtcGxlIiwiY29udGV4dCI6Ilwvc2FtcGxlXC8xLjAuMCIsInB1Ymxpc2hlciI6ImFkbWluIiwidmVyc2lvbiI6IjEuMC4wIiwic3Vic2NyaXB0aW9uVGllciI6IlVubGltaXRlZCJ9XSwiY29uc3VtZXJLZXkiOiJqMWlOVUQ3UUlYQWZIeWlIcWxjUkU2UmE1RTRhIiwiZXhwIjozNzMzMTI4NzM5LCJpYXQiOjE1ODU2NDUwOTIsImp0aSI6ImY1YTM0MWZjLWQxMjgtNDk4OC05ZjBiLTFkM2UzNjczMDIyNiJ9.azyydmzr61Gr7aoJsvpXolb7Udt3Wdk09k7gfTcd40ZJkh3ECE77Vs_-HzVBHFiwbWzkub6UUscP8faLkGuQm2yOgL14qEE7hk85xZ5sZ3Z1AJeY6CkEyZ172LfyK6UjA882TTaf_fwDgKEIOE_YtbJkkNKz1nIrvJD1xFXZSykPLpPXT1TVBxv55M2BpkpHLk-m3Xx4ItFzDvXMiXmoz2qsoDoRm7ERs6XizLfzdUQS7XQFb9lm1lKB-lhGdk2AOKEOsOzfGllISmG52n6Zao1d_jdjpn3W6Cgqd1O6ScctJvOWM3pls_WMzdZD4D_H_uWEi9Oz9pSSq5UwSqfeFQ \
-Gusers=$1 -Gduration=$2 -Gtps=$3 -l results.jtl -Jserver.rmi.ssl.disable=true

#write_server_metrics jmeter
#write_server_metrics analytics1 $api_ssh_host carbon
#write_server_metrics analytics2 analytics.apim.com carbon

#nohup ./run-performance-test.sh 150 1800 180000 > out 2>&1 &
#nohup ./run-performance-test.sh 150 900 30000 -s> out 2>&1 &