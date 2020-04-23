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

#scp -i ssh/apim310.key /Users/rukshan/wso2/apim/3.1.0/performance-common/components/jtl-splitter/target/jtl-splitter-0.4.6-SNAPSHOT.jar ubuntu@client.apim.com:performance-common/distribution/scripts/jtl-splitter/
#scp -i ssh/apim310.key ubuntu@client.apim.com:metrix/data.zip ./


scp -i ssh/apim310.key jks/wso2carbon.jks ubuntu@apim1.apim.com:wso2am-3.1.0/repository/resources/security/
scp -i ssh/apim310.key jks/wso2carbon.jks ubuntu@apim2.apim.com:wso2am-3.1.0/repository/resources/security/
scp -i ssh/apim310.key jks/wso2carbon.jks ubuntu@analytics1.apim.com:wso2am-analytics-3.1.0/resources/security/
scp -i ssh/apim310.key jks/wso2carbon.jks ubuntu@analytics2.apim.com:wso2am-analytics-3.1.0/resources/security/

scp -i ssh/apim310.key jks/client-truststore.jks ubuntu@apim1.apim.com:wso2am-3.1.0/repository/resources/security/
scp -i ssh/apim310.key jks/client-truststore.jks ubuntu@apim2.apim.com:wso2am-3.1.0/repository/resources/security/
scp -i ssh/apim310.key jks/client-truststore.jks ubuntu@analytics1.apim.com:wso2am-analytics-3.1.0/resources/security/
scp -i ssh/apim310.key jks/client-truststore.jks ubuntu@analytics2.apim.com:wso2am-analytics-3.1.0/resources/security/

scp -i ssh/apim310.key run-performance-test.sh ubuntu@client.apim.com:performance-analytics/
scp -i ssh/apim310.key create-summary-csv.sh ubuntu@client1.apim.com:performance-analytics/


scp -i ssh/apim310.key jks/wso2carbon.jks ubuntu@apim1.apim.com:wso2am-3.1.0/repository/resources/security/

wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-3.3.tgz
wget http://atuwa.private.wso2.com/JAVA/ORACLE_JAVA/Linux/JDK8/jdk-8u161-linux-x64.tar.gz

./install-jmeter.sh -i /home/ubuntu -f apache-jmeter-3.3.tgz
sudo ./install-java.sh -f jdk-8u161-linux-x64.tar.gz -p /usr/lib/jvm
JAVA_HOME=/home/ubuntu/jdk1.8.0_161

203.94.95.231   atuwa.private.wso2.com

scp -i ssh/apim310.key ubuntu@client.apim.com:performance-analytics/analytics.jmx ./
scp -i ssh/apim310.key analytics.jmx ubuntu@client.apim.com:performance-analytics

scp -i ssh/apim310.key ubuntu@client.apim.com:summary.csv ./
scp -i ssh/apim310.key ubuntu@client.apim.com:new.csv ./
scp -i ssh/apim310.key ubuntu@client.apim.com:metrix/analytics1_gc.log ./
scp -i ssh/apim310.key ubuntu@client.apim.com:metrix/apim1_gc.log ./
scp -i ssh/apim310.key ubuntu@client.apim.com:performance-analytics/run-performance-test.sh ./diff

rm summary.csv && ./performance-analytics/create-summary-csv.sh gcviewer-1.36.jar

java -Xms128m -Xmx128m -jar gcviewer-1.36.jar metrix/analytics1_gc.log  /tmp/gc.txt -t SUMMARY &> /dev/null

sudo ./install-java.sh -f openjdk-11+28_linux-x64_bin.tar.gz -p /usr/lib/jvm

nohup ./performance-analytics/run-performance-test.sh 150 300 6000 > out 2>&1 &


scp -i ssh/apim310.key wait-apim-start.sh ubuntu@apim1.apim.com:performance-analytics
scp -i ssh/apim310.key wait-apim-start.sh ubuntu@apim2.apim.com:performance-analytics
scp -i ssh/apim310.key wait-apim-start.sh ubuntu@apim3.apim.com:performance-analytics
scp -i ssh/apim310.key wait-apim-start.sh ubuntu@apim4.apim.com:performance-analytics
scp -i ssh/apim310.key wait-apim-start.sh ubuntu@apim5.apim.com:performance-analytics

scp -i ssh/apim310.key apim-start.sh ubuntu@apim1.apim.com:performance-analytics
scp -i ssh/apim310.key apim-start.sh ubuntu@apim2.apim.com:performance-analytics
scp -i ssh/apim310.key apim-start.sh ubuntu@apim3.apim.com:performance-analytics
scp -i ssh/apim310.key apim-start.sh ubuntu@apim4.apim.com:performance-analytics
scp -i ssh/apim310.key apim-start.sh ubuntu@apim5.apim.com:performance-analytics

scp -i ssh/apim310.key analytics-start.sh ubuntu@analytics1.apim.com:performance-analytics
scp -i ssh/apim310.key analytics-start.sh ubuntu@analytics2.apim.com:performance-analytics

######
scp -i ssh/apim310.key active-active/analytics1/worker/deployment.yaml ubuntu@analytics1.apim.com:/home/ubuntu/wso2am-analytics-3.1.0/conf/worker
scp -i ssh/apim310.key active-active/analytics2/worker/deployment.yaml ubuntu@analytics2.apim.com:/home/ubuntu/wso2am-analytics-3.1.0/conf/worker

scp -i ssh/apim310.key active-active/apim1/deployment.toml ubuntu@apim1.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key active-active/apim2/deployment.toml ubuntu@apim2.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key active-active/apim2/deployment.toml ubuntu@apim3.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key active-active/apim2/deployment.toml ubuntu@apim4.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key active-active/apim2/deployment.toml ubuntu@apim5.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/

######
scp -i ssh/apim310.key active-passive/analytics1/worker/deployment.yaml ubuntu@analytics1.apim.com:/home/ubuntu/wso2am-analytics-3.1.0/conf/worker
scp -i ssh/apim310.key active-passive/analytics2/worker/deployment.yaml ubuntu@analytics2.apim.com:/home/ubuntu/wso2am-analytics-3.1.0/conf/worker

scp -i ssh/apim310.key active-passive/apim1/deployment.toml ubuntu@apim1.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key active-passive/apim2/deployment.toml ubuntu@apim2.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key active-passive/apim2/deployment.toml ubuntu@apim3.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key active-passive/apim2/deployment.toml ubuntu@apim4.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key active-passive/apim2/deployment.toml ubuntu@apim5.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/

scp -i ssh/apim310.key log4j2.properties  ubuntu@apim1.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key log4j2.properties  ubuntu@apim2.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key log4j2.properties  ubuntu@apim3.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key log4j2.properties  ubuntu@apim4.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/
scp -i ssh/apim310.key log4j2.properties  ubuntu@apim5.apim.com:/home/ubuntu/wso2am-3.1.0/repository/conf/

scp -i ssh/apim310.key catalina-server.xml.j2 ubuntu@apim1.apim.com:wso2am-3.1.0/repository/resources/conf/templates/repository/conf/tomcat/
scp -i ssh/apim310.key catalina-server.xml.j2 ubuntu@apim2.apim.com:wso2am-3.1.0/repository/resources/conf/templates/repository/conf/tomcat/
scp -i ssh/apim310.key catalina-server.xml.j2 ubuntu@apim3.apim.com:wso2am-3.1.0/repository/resources/conf/templates/repository/conf/tomcat/
scp -i ssh/apim310.key catalina-server.xml.j2 ubuntu@apim4.apim.com:wso2am-3.1.0/repository/resources/conf/templates/repository/conf/tomcat/
scp -i ssh/apim310.key catalina-server.xml.j2 ubuntu@apim5.apim.com:wso2am-3.1.0/repository/resources/conf/templates/repository/conf/tomcat/

scp -i ssh/apim310.key ubuntu@db.apim.com:/home/ubuntu/.ssh/id_rsa.pub ./
scp -i ssh/apim310.key id_rsa.pub ubuntu@192.168.112.3:/home/ubuntu/.ssh/
scp -i ssh/apim310.key ubuntu@analytics1.apim.com:/home/ubuntu/dump/dump.zip ./

scp -i ssh/apim310.key ubuntu@client1.apim.com:metrix/apim3_gc.log ./

./jstack-profiler -p 1515 -o dump