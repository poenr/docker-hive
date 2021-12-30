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

hdfs dfs -ls /tmp >/dev/null 2>&1
if [ $? -eq 1 ];then
hdfs dfs -mkdir       /tmp
fi

hdfs dfs -ls /user/hive/warehouse >/dev/null 2>&1
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /user/hive/warehouse
fi

hdfs dfs -ls /user/hive/tmp >/dev/null 2>&1
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /user/hive/tmp
fi

hdfs dfs -ls /user/hive/log >/dev/null 2>&1
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /user/hive/log
fi

hdfs dfs -ls /rmstate >/dev/null 2>&1
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /rmstate
fi

hdfs dfs -ls /app-logs >/dev/null 2>&1
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /app-logs
fi

hdfs dfs -ls /tmp/hadoop-yarn >/dev/null 2>&1
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /tmp/hadoop-yarn
fi

hdfs dfs -ls /tmp/hive/hadoop >/dev/null 2>&1
if [ $? -eq 1 ];then
hdfs dfs -mkdir -p    /tmp/hive/hadoop
fi

hdfs dfs -chmod -R g+w /tmp >/dev/null 2>&1
hdfs dfs -chmod -R g+w /tmp/hadoop-yarn >/dev/null 2>&1
hdfs dfs -chmod -R g+w /tmp/hive >/dev/null 2>&1
hdfs dfs -chmod -R g+w /tmp/hive/hadoop >/dev/null 2>&1

hdfs dfs -chmod -R g+w /user >/dev/null 2>&1
hdfs dfs -chmod -R g+w /user/hive/warehouse >/dev/null 2>&1
hdfs dfs -chmod -R g+w /user/hive/tmp >/dev/null 2>&1
hdfs dfs -chmod -R g+w /user/hive/log >/dev/null 2>&1

hdfs dfs -chmod -R g+w /rmstate >/dev/null 2>&1
hdfs dfs -chmod -R g+w /app-logs >/dev/null 2>&1

hdfs dfs -chmod -R 1777 /tmp
hdfs dfs -chmod -R 1777 /app-logs
hdfs dfs -chmod -R 1777 /user/hive/

#initiate hive metedata server
$HIVE_HOME/bin/schematool -dbType mysql -initSchema
echo "schematool -dbType mysql -initSchema ok"

./hive --hiveconf hive.server2.enable.doAs=false --service hiveserver2 &
echo "hiveserver2 --hiveconf hive.server2.enable.doAs=false ok"

./hive -S -e "set role admin;"
./hive -S -e "CREATE DATABASE  if not exists ljgk_dw;"
./hive -S -e "set role admin;GRANT ALL ON DATABASE default TO user hadoop;"
./hive -S -e "set role admin;GRANT ALL ON DATABASE ljgk_dw TO user hadoop;"
./hive -S -e "CREATE TABLE  if not exists pokes (foo INT, bar STRING);"
./hive -S -e "LOAD DATA LOCAL INPATH '/opt/hive/examples/files/kv1.txt' OVERWRITE INTO TABLE pokes;"

echo "CREATE DATABASE、DB AND LOAD DATA ok"

tail -f /dev/null




