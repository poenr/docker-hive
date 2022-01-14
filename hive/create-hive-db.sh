#!/bin/bash
set -e

./hive -e "CREATE DATABASE ljgk_dw; 
                       GRANT ALL  ON DATABASE default TO user hadoop;
                       GRANT ALL  ON DATABASE ljgk_dw TO user hadoop;
                       CREATE TABLE pokes (foo INT, bar STRING);
                       LOAD DATA LOCAL INPATH '/opt/hive/examples/files/kv1.txt' OVERWRITE INTO TABLE pokes;" 

