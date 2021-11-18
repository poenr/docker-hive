FROM harbor.software.dc/mpdata/hadoop-base:2.0.0-hadoop2.7.4-java8
LABEL  maintainer="凌久高科软件开发中心 <rjkfzx@linjo.cn>"

# Allow buildtime config of HIVE_VERSION
ARG HIVE_VERSION
# Set HIVE_VERSION from arg if provided at build, env if provided at run, or default
# https://docs.docker.com/engine/reference/builder/#using-arg-variables
# https://docs.docker.com/engine/reference/builder/#environment-replacement
ENV HIVE_VERSION=${HIVE_VERSION:-1.2.1}

ENV HIVE_HOME /opt/hive
ENV PATH $HIVE_HOME/bin:$PATH
ENV HADOOP_HOME /opt/hadoop-$HADOOP_VERSION

WORKDIR /opt

#Install Hive and PostgreSQL JDBC
COPY apache-hive-$HIVE_VERSION-bin.tar.gz ./
RUN tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
	mv apache-hive-$HIVE_VERSION-bin hive && \
	rm apache-hive-$HIVE_VERSION-bin.tar.gz && \
	rm -rf /var/lib/apt/lists/*

COPY lib/postgresql-9.4.1212.jar $HIVE_HOME/lib/postgresql-jdbc.jar

RUN ls -l /opt/hive/

#Spark should be compiled with Hive to be able to use it
#hive-site.xml should be copied to $SPARK_HOME/conf folder

#Custom configuration goes here
ADD conf/hive-site.xml $HIVE_HOME/conf
ADD conf/beeline-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-env.sh $HIVE_HOME/conf
ADD conf/hive-exec-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-log4j2.properties $HIVE_HOME/conf
ADD conf/ivysettings.xml $HIVE_HOME/conf
ADD conf/llap-daemon-log4j2.properties $HIVE_HOME/conf

# 添加hive元数据hook插件 apache-atlas-2.1.0-hive-hook
RUN mkdir /opt/atlas
ADD hook/apache-atlas-2.1.0-hive-hook.tar.gz /opt/atlas
# 替换hadoop-common的加载的configuration包org.apache.hadoop.conf.Configuration
RUN rm -rf /opt/hive/lib/commons-configuration-1.6.jar
RUN cp /opt/atlas/apache-atlas-hive-hook-2.1.0/hook/hive/atlas-hive-plugin-impl/commons-configuration-1.10.jar /opt/hive/lib/

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 10000
EXPOSE 10002

ENTRYPOINT ["entrypoint.sh"]
CMD startup.sh
