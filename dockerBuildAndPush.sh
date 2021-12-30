#!/bin/bash
docker build -t harbor.software.dc/mpdata/hive:2.3.9-mysql-metastore -f Dockerfile ./
docker push harbor.software.dc/mpdata/hive:2.3.9-mysql-metastore
