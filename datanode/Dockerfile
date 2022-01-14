FROM harbor.software.dc/mpdata/hadoop-base:2.0.0-hadoop2.7.4-java8
LABEL  maintainer="凌久高科软件开发中心 <rjkfzx@linjo.cn>"

HEALTHCHECK CMD curl -f http://localhost:50075/ || exit 1

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 50075

CMD ["/run.sh"]
