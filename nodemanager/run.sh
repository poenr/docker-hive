#!/bin/bash

#$HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR nodemanager

$HADOOP_PREFIX/sbin/yarn-daemon.sh start nodemanager
echo "nodemanager start ok"
ls -l $HADOOP_PREFIX/logs

tail -f /dev/null
