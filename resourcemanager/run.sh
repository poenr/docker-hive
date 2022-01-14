#!/bin/bash

#$HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR resourcemanager

$HADOOP_PREFIX/sbin/yarn-daemon.sh start resourcemanager
echo "resourcemanager start ok"
ls -l $HADOOP_PREFIX/logs
tail -f /dev/null