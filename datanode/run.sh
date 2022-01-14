#!/bin/bash

datadir=`echo $HDFS_CONF_dfs_datanode_data_dir | perl -pe 's#file://##'`
if [ ! -d $datadir ]; then
  echo "Datanode data directory not found: $datadir"
  exit 2
fi

#$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR datanode

$HADOOP_PREFIX/sbin/hadoop-daemon.sh start datanode
echo "hdfs datanode start ok"
ls -l $HADOOP_PREFIX/logs
tail -f /dev/null
