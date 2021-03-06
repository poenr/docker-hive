# hive容器镜像,本分支为元数据使用mysql的版本

* 本项目涉及到1个镜像的制作，使用hive2.3.9版本
```
hive-server和hive-metastore服务共同使用的hive:2.3.9-mysql-metastore镜像
```
* 本项目可直接快速启动一个包含hadoop及hive的容器环境,具体参考```docker-compose.yml```
```
#除hive-server和hive-metastore服务使用本项目中的Dockerfile构建外，其他服务具体请看其他镜像部分的说明

#启动脚本
git clone http://gitlab.software.dc/mp-data/dss/docker-hive.git
cd docker-hive
git checkout 2.3.9-mysql-metastore
docker-compose up -d
docker-compose logs -f hive-server

#测试HDFS服务是否正常
docker-compose exec hive-server /bin/bash -c 'hdfs dfs -ls /'

#测试Hive服务是否正常
docker-compose exec hive-server /bin/bash -c 'hive -S -e "show databases;"'
docker-compose exec hive-server /bin/bash -c 'hive -S -e "select * from default.pokes;"'

```
* 端口开放列表

|   节点             | 用途                | 容器端口     | 主机端口 |  说明                                             |
| --------------   | -------------------     | ------------| ---------|------------------------------------------------ |
| namenode        |fs.defaultFS                |  8020    |8020
| namenode        |dfs.namenode.http.address   |  50070   |50070
| datanode        |dfs.datanode.address        |  50010   |50010
| datanode        |dfs.datanode.ipc.address    |  50020   |50020
| datanode        |dfs.datanode.http.address   |  50075   |50075
| nodemanager     |yarn.nodemanager.localizer.address       |  8040   |8040
| nodemanager     |yarn.nodemanager.address                 |  8041   |8041
| nodemanager     |yarn.nodemanager.webapp.address          |  8042   |8042
| resourcemanager |yarn.resourcemanager.scheduler.address        |  8030   |8030
| resourcemanager |yarn.resourcemanager.resource-tracker.address |  8031   |8031
| resourcemanager |yarn.resourcemanager.address                  |  8032   |8032
| resourcemanager |yarn.resourcemanager.webapp.address           |  8088   |8088
| historyserver   |mapreduce.jobhistory.webapp.address   |  19888   |19888
| historyserver   |mapreduce.jobhistory.address          |  10020  |10020
| historyserver   |yarn.timeline-service.webapp.address  |  8188   |8188 | timelineseerver端口和historyserver共用容器
| historyserver   |yarn.timeline-service.address  |  10200   |10200 | timelineseerver端口和historyserver共用容器
| hive-server   |hive.server2.thrift.port  |  10000   |10000
| hive-server   |hive.server2.webui.port  |  10002   |10002 | hive2.0以上版本支持web UI
| hive-metastore-mysql  |mysql  |  3306   |13306 | 数据库端口
| hive-metastore |metastore  |  9083   |9083 | 元数据服务端口



## hive:2.3.9-mysql-metastore镜像
此镜像Dockerfile中包括hive2.3.9版本的安装、hive启动脚本及atlas hive hook插件的安装，其中atlas插件根据环境变量参数选择是否启用，具体参考```entrypoint.sh```

* 镜像制作脚本
```
git clone http://gitlab.software.dc/mp-data/dss/docker-hive.git
cd docker-hive
git checkout 2.3.9-mysql-metastore
docker build -t  harbor.software.dc/mpdata/hive:2.3.9-mysql-metastore -f Dockerfile ./
docker push harbor.software.dc/mpdata/hive:2.3.9-mysql-metastore
```

* 添加hive集成Atlas插件/对Dockerfile进行优化,根据环境变量选择是否启动Atlas插件
```
if [ -n "$ATLAS_HOOK" ]&&[ "$ATLAS_HOOK" = "true" ]&&[ `grep -c "HiveHook" /opt/hive/conf/hive-site.xml` -eq '0' ] ; then
echo " - add atlas hook -"
addProperty /opt/hive/conf/hive-site.xml hive.exec.post.hooks org.apache.atlas.hive.hook.HiveHook
echo "export HIVE_AUX_JARS_PATH=/opt/atlas/apache-atlas-hive-hook-2.1.0/hook/hive">>/opt/hive/conf/hive-env.sh
fi
```
* atlas配置文件/opt/hive/conf/atlas-application.properties
```
atlas.rest.address=http://atlas-server:21000
```

* 测试hive元数据同步到Atlas
```
#创建新表同步到Atlas
docker-compose exec hive-server /bin/bash -c 'hive -S -e "create table ljgk_dw.d_area3(id int, name string) row format delimited fields terminated by \"\t\";"'
#创建新表生成数据血缘数据
docker-compose exec hive-server /bin/bash -c 'hive -S -e "create table ljgk_dw.d_area1 as select * from ljgk_dw.d_area;"'
```

# 其他镜像
* 本项目docker-compose.yml还包含其他镜像
1. hive-metastore-mysql服务使用的mysql:5.7镜像
2. Hadoop组件相关的镜像
## mysql:5.7
此镜像为hive使用的元数据库，使用mysql数据库5.7版本
```
docker pull mysql:5.7
docker tag mysql:5.7 harbor.software.dc/mysql/mysql:5.7
```
## Hadoop组件相关的镜像
```
#其中hadoop-base基础镜像需要替换部分文件，其他镜像在基础镜像基础上重新编译
# hadoop配置下的mapred-site.xml和yarn-env.sh
# hive配置下的hive-site.xml
vim ./base/DockerFile

docker build -t harbor.software.dc/mpdata/hadoop-base:2.0.0-hadoop2.7.4-java8 ./base

docker build -t harbor.software.dc/mpdata/hadoop-namenode:2.0.0-hadoop2.7.4-java8 ./namenode
docker build -t harbor.software.dc/mpdata/hadoop-datanode:2.0.0-hadoop2.7.4-java8 ./datanode
docker build -t harbor.software.dc/mpdata/hadoop-resourcemanager:2.0.0-hadoop2.7.4-java8 ./resourcemanager
docker build -t harbor.software.dc/mpdata/hadoop-nodemanager:2.0.0-hadoop2.7.4-java8 ./nodemanager
docker build -t harbor.software.dc/mpdata/hadoop-historyserver:2.0.0-hadoop2.7.4-java8 ./historyserver
docker build -t harbor.software.dc/mpdata/hadoop-submit:2.0.0-hadoop2.7.4-java8 ./submit

#镜像上传到harbor

docker push harbor.software.dc/mpdata/hadoop-namenode:2.0.0-hadoop2.7.4-java8
docker push harbor.software.dc/mpdata/hadoop-datanode:2.0.0-hadoop2.7.4-java8
docker push harbor.software.dc/mpdata/hadoop-resourcemanager:2.0.0-hadoop2.7.4-java8
docker push harbor.software.dc/mpdata/hadoop-nodemanager:2.0.0-hadoop2.7.4-java8
docker push harbor.software.dc/mpdata/hadoop-historyserver:2.0.0-hadoop2.7.4-java8
docker push harbor.software.dc/mpdata/hadoop-submit:2.0.0-hadoop2.7.4-java8

```

hadoop容器镜像制作,请使用分支2.0.0-hadoop2.7.4-java8

```
具体镜像制作方法详见http://gitlab.software.dc/mp-data/dss/docker-hadoop/-/tree/2.0.0-hadoop2.7.4-java8，！！！此工程已不在维护！！！
```
[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/big-data-europe/Lobby)

# docker-hive

## Testing
Load data into Hive:
```
  $ docker-compose exec hive-server bash
  # /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
  > CREATE TABLE pokes (foo INT, bar STRING);
  > LOAD DATA LOCAL INPATH '/opt/hive/examples/files/kv1.txt' OVERWRITE INTO TABLE pokes;
```

Then query it from PrestoDB. You can get [presto.jar](https://prestosql.io/docs/current/installation/cli.html) from PrestoDB website:
```
  $ wget https://repo1.maven.org/maven2/io/prestosql/presto-cli/308/presto-cli-308-executable.jar
  $ mv presto-cli-308-executable.jar presto.jar
  $ chmod +x presto.jar
  $ ./presto.jar --server localhost:8080 --catalog hive --schema default
  presto> select * from pokes;
```

## Contributors
* Ivan Ermilov [@earthquakesan](https://github.com/earthquakesan) (maintainer)
* Yiannis Mouchakis [@gmouchakis](https://github.com/gmouchakis)
* Ke Zhu [@shawnzhu](https://github.com/shawnzhu)
