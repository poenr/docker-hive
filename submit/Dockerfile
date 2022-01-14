FROM harbor.software.dc/mpdata/hadoop-base:2.0.0-hadoop2.7.4-java8
LABEL  maintainer="凌久高科软件开发中心 <rjkfzx@linjo.cn>"

COPY WordCount.jar /opt/hadoop/applications/WordCount.jar

ENV JAR_FILEPATH="/opt/hadoop/applications/WordCount.jar"
ENV CLASS_TO_RUN="WordCount"
ENV PARAMS="/input /output"

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
