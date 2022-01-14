#!/bin/bash

#base
docker build -t harbor.software.dc/mpdata/hadoop-base:2.0.0-hadoop2.7.4-java8 ./base --squash
docker push  harbor.software.dc/mpdata/hadoop-base:2.0.0-hadoop2.7.4-java8

#hadoop
docker build -t harbor.software.dc/mpdata/hadoop-namenode:2.0.0-hadoop2.7.4-java8 ./namenode --squash
docker build -t harbor.software.dc/mpdata/hadoop-datanode:2.0.0-hadoop2.7.4-java8 ./datanode --squash
docker build -t harbor.software.dc/mpdata/hadoop-resourcemanager:2.0.0-hadoop2.7.4-java8 ./resourcemanager --squash
docker build -t harbor.software.dc/mpdata/hadoop-nodemanager:2.0.0-hadoop2.7.4-java8 ./nodemanager --squash
docker build -t harbor.software.dc/mpdata/hadoop-historyserver:2.0.0-hadoop2.7.4-java8 ./historyserver --squash
docker build -t harbor.software.dc/mpdata/hadoop-submit:2.0.0-hadoop2.7.4-java8 ./submit --squash

docker push harbor.software.dc/mpdata/hadoop-namenode:2.0.0-hadoop2.7.4-java8
docker push harbor.software.dc/mpdata/hadoop-datanode:2.0.0-hadoop2.7.4-java8
docker push harbor.software.dc/mpdata/hadoop-resourcemanager:2.0.0-hadoop2.7.4-java8
docker push harbor.software.dc/mpdata/hadoop-nodemanager:2.0.0-hadoop2.7.4-java8
docker push harbor.software.dc/mpdata/hadoop-historyserver:2.0.0-hadoop2.7.4-java8
docker push harbor.software.dc/mpdata/hadoop-submit:2.0.0-hadoop2.7.4-java8

#hive
docker build -t harbor.software.dc/mpdata/hive:2.3.9-mysql-metastore ./hive --squash
docker push harbor.software.dc/mpdata/hive:2.3.9-mysql-metastore
