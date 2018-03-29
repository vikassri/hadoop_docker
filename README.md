# Debian + open Java 8  + Hadoop 2.7.3

## Versions
- sbt: **0.13.15**
- java: **1.8.0_162**
- python **3.5.3**
- hadoop: **2.7.3**
- hive **2.0.1**

## Installation
```
docker-compose up -d
```

## Running
To simply run the container[bash]:
```
docker run -it test_hadoop bash
```

## Dode
Code are in /home/scripts/src/

## Data
/home/data

## Database (Hive)
db:  weather
- historical data:  weather_history
- forecast data  : weather_trans