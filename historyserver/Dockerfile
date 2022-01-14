FROM harbor.software.dc/mpdata/hadoop-base:2.0.0-hadoop2.7.4-java8

HEALTHCHECK CMD curl -f http://localhost:8188/ || exit 1

ENV YARN_CONF_yarn_timeline___service_leveldb___timeline___store_path=/hadoop/yarn/timeline
COPY ./mapred-site.xml /opt/hadoop-2.7.4/etc/hadoop/mapred-site.xml
RUN mkdir -p /hadoop/yarn/timeline
VOLUME /hadoop/yarn/timeline

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
