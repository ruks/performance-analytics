# Performance testing on Analytics 3.1.0

##Setting up servers

### Following instances are used for the performance testing

- client.apim.com 
- server1.apim.com
- server2.apim.com
- netty.apim.com 
- db.apim.com
- apim1.apim.com
- apim2.apim.com
- apim3.apim.com
- apim4.apim.com
- apim5.apim.com
- analytics1.apim.com
- analytics2.apim.com


### Install java
- checkout https://github.com/wso2/performance-common
- download jdk
- install java with following command
``` 
sudo distribution/scripts/java/install-java.sh -f jdk-8u161-linux-x64.tar.gz -p /usr/lib/jvm
```
- install this on every nodes except db node

### Install jmeter 
- download jmeter tgz binary
- install jmeter with following command
```
    distribution/scripts/jmeter/install-jmeter.sh -i /home/ubuntu -f apache-jmeter-3.3.tgz
```
- install this in client and both servers

### configure apim 
- checkout https://github.com/wso2/performance-apim
- Download and install apim on ~/home directory
- update the ~/performance-analytics/apim-start.sh with correct APIM paths

### configure apim analytics
- checkout https://github.com/wso2/performance-apim
- Download and install apim analytics on ~/home directory
- update the ~/performance-analytics/analytics-start.sh with correct paths

### configure databases
- run ~/performance-analytics/db_setup.sh after validating the configs

### run the performance test
- performance-analytics/run-performance-test.sh need to execute  
- performance-analytics/run-performance-test.sh <no of users> <duration in minutes> <expected TPS>
- ex:
```
nohup ./performance-analytics/run-performance-test.sh 300 300 7000 > out 2>&1 & 
```

### Once the performance is done summary will generate in ~/home directory
- summary_30m_7000tps_aa.csv