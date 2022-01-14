#!/bin/bash

#$HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR historyserver

$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver
echo "historyserver start ok"
$HADOOP_PREFIX/sbin/yarn-daemon.sh start timelineserver
echo "timelineserver start ok"
ls -l $HADOOP_PREFIX/logs

tail -f /dev/null

