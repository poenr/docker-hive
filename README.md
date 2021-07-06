# hive容器镜像制作,请使用分支master

* 本项目涉及到1个镜像的制作，使用hive1.2.1版本
1. hive-server和hive-metastore服务共同使用的hive:1.2.1-postgresql-metastore镜像
## hive:1.2.1-postgresql-metastore镜像
此镜像Dockerfile中包括hive1.2.1版本的安装、hive启动脚本及atlas hive hook插件的安装，其中atlas插件根据环境变量参数选择是否启用，具体参考entrypoint.sh
```

git clone http://gitlab.software.dc/mp-data/dss/docker-hive.git
cd docker-hive
docker build -t  harbor.software.dc/mpdata/hive:1.2.1-postgresql-metastore -f Dockerfile ./
docker push harbor.software.dc/mpdata/hive:1.2.1-postgresql-metastore


```
# 其他镜像
* 本项目docker-compose.yml还包含hive-metastore-postgresql服务使用的hive-metastore-postgresql:1.2.0镜像及Hadoop组件相关的镜像
## hive-metastore-postgresql:1.2.0镜像
此镜像为hive使用的元数据库，使用postgresql数据库postgres:9.5.3版本
```
git clone http://gitlab.software.dc/mp-data/dss/docker-hive-metastore-postgresql.git
cd docker-hive-metastore-postgresql

docker build -t  harbor.software.dc/mpdata/hive-metastore-postgresql:1.2.0 -f Dockerfile ./
docker push harbor.software.dc/mpdata/hive-metastore-postgresql:1.2.0
```
## Hadoop组件相关的镜像
```
具体镜像制作方法详见http://gitlab.software.dc/mp-data/dss/docker-hadoop/-/tree/2.0.0-hadoop2.7.4-java8
```
[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/big-data-europe/Lobby)

# docker-hive

This is a docker container for Apache Hive 2.3.2. It is based on https://github.com/big-data-europe/docker-hadoop so check there for Hadoop configurations.
This deploys Hive and starts a hiveserver2 on port 10000.
Metastore is running with a connection to postgresql database.
The hive configuration is performed with HIVE_SITE_CONF_ variables (see hadoop-hive.env for an example).

To run Hive with postgresql metastore:
```
    docker-compose up -d
```

To deploy in Docker Swarm:
```
    docker stack deploy -c docker-compose.yml hive
```

To run a PrestoDB 0.181 with Hive connector:

```
  docker-compose up -d presto-coordinator
```

This deploys a Presto server listens on port `8080`

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
