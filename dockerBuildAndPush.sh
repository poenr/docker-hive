#!/bin/bash
docker build -t harbor.software.dc/mpdata/hive:1.2.1-mysql-metastore -f Dockerfile ./
docker push harbor.software.dc/mpdata/hive:1.2.1-mysql-metastore
