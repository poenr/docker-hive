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


#initiate hive metedata server
$HIVE_HOME/bin/schematool -dbType mysql -initSchema
echo "schematool -dbType mysql -initSchema ok"

#start hive metastore
$HIVE_HOME/bin/hive --service metastore
echo "start hive metastore ok"


tail -f /dev/null




