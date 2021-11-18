#!/bin/bash

cd $HIVE_HOME/bin

for i in `seq 1 30`
do
    hdfs dfsadmin -safemode get | grep ON
    if [ $? -ne 0 ] ;then
        break;
    else
        echo "HDFS in Safe mode..."
        sleep 1
    fi
done

hdfs dfs -ls /tmp 2>/dev/null
if [ $? -eq 1 ];then
hdfs dfs -mkdir       /tmp
fi

hdfs dfs -ls /user/hive/warehouse 2>/dev/null
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /user/hive/warehouse
fi

hdfs dfs -ls /user/hive/tmp 2>/dev/null
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /user/hive/tmp
fi

hdfs dfs -ls /user/hive/log 2>/dev/null
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /user/hive/log
fi

hdfs dfs -ls /rmstate 2>/dev/null
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /rmstate
fi

hdfs dfs -ls /app-logs 2>/dev/null
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /app-logs
fi

hdfs dfs -ls /tmp/hadoop-yarn 2>/dev/null
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /tmp/hadoop-yarn
fi

hdfs dfs -ls /tmp/hive/hadoop 2>/dev/null
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /tmp/hive/hadoop
fi

hdfs dfs -chmod -R g+w /tmp 2>/dev/null
hdfs dfs -chmod -R g+w /user/hive/warehouse 2>/dev/null
hdfs dfs -chmod -R g+w /user/hive/tmp 2>/dev/null
hdfs dfs -chmod -R g+w /user/hive/log 2>/dev/null
hdfs dfs -chmod -R g+w /rmstate 2>/dev/null
hdfs dfs -chmod -R g+w /app-logs 2>/dev/null
 
#hdfs dfs -chown -R hadoop:hadoop /

hdfs dfs -chmod -R 777 /tmp/hadoop-yarn

hdfs dfs -chmod -R 777 /tmp/hive/hadoop

./hive -S -e "CREATE DATABASE  if not exists ljgk_dw;"
./hive -S -e "GRANT ALL ON DATABASE default TO user hadoop;"
./hive -S -e "GRANT ALL ON DATABASE ljgk_dw TO user hadoop;"
./hive -S -e "CREATE TABLE  if not exists pokes (foo INT, bar STRING);"
./hive -S -e "LOAD DATA LOCAL INPATH '/opt/hive/examples/files/kv1.txt' OVERWRITE INTO TABLE pokes;"

./hiveserver2 --hiveconf hive.server2.enable.doAs=false

tail -f /dev/null




