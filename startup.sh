#!/bin/bash

hadoop fs -ls /tmp
if [ $? -eq 1 ];then
hadoop fs -mkdir       /tmp
fi

hadoop fs -ls /user/hive/warehouse
if [ $? -eq 1 ];then
hadoop fs -mkdir -p    /user/hive/warehouse
fi

hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse

cd $HIVE_HOME/bin
./hive -e "CREATE DATABASE  if not exists ljgk_dw; 
           GRANT ALL  ON DATABASE default TO user hadoop;
           GRANT ALL  ON DATABASE ljgk_dw TO user hadoop;
           CREATE TABLE  if not exists pokes (foo INT, bar STRING);
           LOAD DATA LOCAL INPATH '/opt/hive/examples/files/kv1.txt' OVERWRITE INTO TABLE pokes;"

./hiveserver2 --hiveconf hive.server2.enable.doAs=false


