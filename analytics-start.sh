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
# Start WSO2 API Manager
# ----------------------------------------------------------------------------

heap_size=$1
if [[ -z $heap_size ]]; then
    heap_size="4"
fi

export JAVA_HOME="/opt/jdk-11"

apim_version=3.1.0
carbon_bootstrap_class=org.wso2.carbon.launcher.Main

if pgrep -f "$carbon_bootstrap_class" > /dev/null; then
    echo "Shutting down Analytics"
    $HOME/wso2am-analytics-${apim_version}/bin/worker.sh stop
fi

echo "Waiting for API Manager Analytics to stop"

while true
do
    if ! pgrep -f "$carbon_bootstrap_class" > /dev/null; then
        echo "API Manager Analytics stopped"
        break
    else
        sleep 10
    fi
done

log_files=($HOME/wso2am-analytics-${apim_version}/wso2/worker/logs/*)
if [ ${#log_files[@]} -gt 1 ]; then
    echo "Log files exists. Moving to /tmp"
    mv $HOME/wso2am-analytics-${apim_version}/wso2/worker/logs/* /tmp/;
fi

echo "Setting Heap to ${heap_size}GB"
export JVM_MEM_OPTS="-Xms2G -Xmx${heap_size}G"

echo "Enabling GC Logs"
#-XX:+PrintGCDateStamps
export JAVA_OPTS="-XX:+PrintGC -XX:+PrintGCDetails -Xloggc:$HOME/wso2am-analytics-${apim_version}/wso2/worker/logs/gc.log"

echo "Starting APIM - $HOME/wso2am-analytics-${apim_version}/bin/wso2server.sh start"
$HOME/wso2am-analytics-${apim_version}/bin/worker.sh start

echo "Waiting for API Manager Analytics to start"

while true 
do
    # Check Version service
    response_code="$(curl -H "accept: application/json" -u admin:admin -sk -w "%{http_code}" -o /dev/null https://localhost:9445/siddhi-apps?isActive=true)"
    if [ $response_code -eq 200 ]; then
        echo "API Manager Analytics started"
        break
    else
        sleep 10
    fi
done

# Wait for another 10 seconds to make sure that the server is ready to accept API requests.
sleep 10
