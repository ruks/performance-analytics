#!/bin/bash
#scp -i ssh/apim310.key apim1/deployment.toml ubuntu@apim1.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
#scp -i ssh/apim310.key apim2/deployment.toml ubuntu@apim2.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
#
#scp -i ssh/apim310.key analytics1/worker/deployment.yaml ubuntu@analytics1.apim.com:/home/ubuntu/wso2am-analytics-3.1.0/conf/worker
#scp -i ssh/apim310.key analytics2/worker/deployment.yaml ubuntu@analytics2.apim.com:/home/ubuntu/wso2am-analytics-3.1.0/conf/worker
#
#scp -i ssh/apim310.key analytics1/dashboard/deployment.yaml ubuntu@analytics1.apim.com:/home/ubuntu/wso2am-analytics-3.1.0/conf/dashboard
#scp -i ssh/apim310.key analytics2/dashboard/deployment.yaml ubuntu@analytics2.apim.com:/home/ubuntu/wso2am-analytics-3.1.0/conf/dashboard
#
#scp -i ssh/apim310.key lib/mysql-connector-java-5.1.48.jar ubuntu@apim1.apim.com:/home/ubuntu/wso2am-3.1.0/repository/components/lib/
#scp -i ssh/apim310.key lib/mysql-connector-java-5.1.48.jar ubuntu@apim2.apim.com:/home/ubuntu/wso2am-3.1.0/repository/components/lib/
#
#scp -i ssh/apim310.key lib/mysql_connector_java_5.1.48_1.0.0.jar ubuntu@analytics1.apim.com:/home/ubuntu/wso2am-analytics-3.1.0/lib
#scp -i ssh/apim310.key lib/mysql_connector_java_5.1.48_1.0.0.jar ubuntu@analytics2.apim.com:/home/ubuntu/wso2am-analytics-3.1.0/lib


scp -i ssh/apim310.key jks/wso2carbon.jks ubuntu@apim1.apim.com:wso2am-3.1.0/repository/resources/security/
scp -i ssh/apim310.key jks/wso2carbon.jks ubuntu@apim2.apim.com:wso2am-3.1.0/repository/resources/security/
scp -i ssh/apim310.key jks/wso2carbon.jks ubuntu@analytics1.apim.com:wso2am-analytics-3.1.0/resources/security/
scp -i ssh/apim310.key jks/wso2carbon.jks ubuntu@analytics2.apim.com:wso2am-analytics-3.1.0/resources/security/

scp -i ssh/apim310.key jks/client-truststore.jks ubuntu@apim1.apim.com:wso2am-3.1.0/repository/resources/security/
scp -i ssh/apim310.key jks/client-truststore.jks ubuntu@apim2.apim.com:wso2am-3.1.0/repository/resources/security/
scp -i ssh/apim310.key jks/client-truststore.jks ubuntu@analytics1.apim.com:wso2am-analytics-3.1.0/resources/security/
scp -i ssh/apim310.key jks/client-truststore.jks ubuntu@analytics2.apim.com:wso2am-analytics-3.1.0/resources/security/
