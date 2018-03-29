create database IF NOT EXISTS `weather`;

use weather;
CREATE TABLE IF NOT EXISTS `weather_history` ( dt date, 
    tmax float, tmin float, rain float, city_name varchar(20))
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS TEXTFILE;

CREATE TABLE  IF NOT EXISTS `weather_trans` ( dt date, 
    hour int, tmax float, tmin float,rain float, type varchar(10), city_name varchar(20))
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' STORED AS TEXTFILE;



