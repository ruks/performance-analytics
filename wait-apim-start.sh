#!/bin/bash
while true
do
    # Check Version service
    response_code="$(curl -sk -w "%{http_code}" -o /dev/null https://localhost:8243/services/Version)"
    if [ $response_code -eq 200 ]; then
        echo "API Manager started"
        break
    else
        sleep 10
    fi
done


