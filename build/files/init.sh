#!/bin/bash

echo "Starting docker, this will take around 30 seconds"

if [ ! -d "/data/hive/metastore_db" ]; then
	echo "Setting up metastore"
    cd /data/hive
    $HIVE_HOME/bin/schematool -dbType derby -initSchema
    cd
fi
echo "starting hadoop services"

hadoop-daemon.sh start namenode
hadoop-daemon.sh start datanode
yarn-daemon.sh start resourcemanager
yarn-daemon.sh start nodemanager

runjar=`jps | grep "RunJar" | awk '{print $2}'`

if [ -z $runjar ]; then
	nohup $HIVE_HOME/bin/hive --service metastore &
fi

for i in root /data/hive/warehouse 
do
	hadoop fs -mkdir -p $i 
done


rm -f /home/data/*

echo "creating the tables"
hive -f /home/scripts/sql/create_table.sql

echo "downloading the historical dataset"
python /home/scripts/src/history_data_download.py

echo "downloading the current dataset"
python /home/scripts/src/download_current.py

echo "downloading the forecast dataset"
python /home/scripts/src/download_forecast.py

bash
