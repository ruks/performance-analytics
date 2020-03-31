
am_home=/Users/rukshan/wso2/apim/3.1.0/wso2am-3.1.0

#./db_setup.sh mysql /home/ubuntu/ansible-apim/files/packs/wso2am-3.1.0 db.apim.com

mysql -uamuser -pPass@123 -hdb.apim.com<<EOF

    drop database if exists amdb;
    create database amdb;
    use amdb;
    source /Users/rukshan/wso2/apim/3.1.0/wso2am-3.1.0/dbscripts/apimgt/mysql.sql;

    drop database if exists sharedDB;
    create database sharedDB;
    use sharedDB;
    source /Users/rukshan/wso2/apim/3.1.0/wso2am-3.1.0/dbscripts/mysql.sql;

	drop database if exists APIM_ANALYTICS_DB;
	create database APIM_ANALYTICS_DB;

	drop database if exists WSO2_CLUSTER_DB;
	create database WSO2_CLUSTER_DB;

	drop database if exists PERSISTENCE_DB;
	create database PERSISTENCE_DB;

	SET GLOBAL max_connections = 500;
EOF

