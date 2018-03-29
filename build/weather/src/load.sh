#!/bin/bash

file=$1
type=$2

if [ $type == "forecast" ]; then
	hive -e "load data local inpath '$file' into table weather.weather_trans"
elif [ $type == "current" ]; then
	hive -e "load data local inpath '$file' into table weather.weather_trans"
elif [ $type == "history" ]; then
	hive -e "load data local inpath '$file' into table weather.weather_history"
fi 