FROM debian:9
LABEL  maintainer="凌久高科软件开发中心 <rjkfzx@linjo.cn>"

#RUN sed -i 's#http://deb.debian.org#http://mirror.aliyun.com#g' /etc/apt/sources.list
#RUN sed -i 's#http://security.debian.org#http://mirror.aliyun.com#g' /etc/apt/sources.list

COPY sources.list.stretch /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated java-common net-tools curl netcat wget procps vim telnet

#COPY amazon-corretto-8-x64-linux-jdk.deb /tmp/amazon-corretto-8-x64-linux-jdk.deb
RUN wget -c http://dl.software.dc/dist/amazon-corretto-8-x64-linux-jdk.deb -O /tmp/amazon-corretto-8-x64-linux-jdk.deb
RUN dpkg --install /tmp/amazon-corretto-8-x64-linux-jdk.deb && rm -rf /tmp/amazon-corretto-8-x64-linux-jdk.deb
RUN ls -l /usr/lib/jvm/java-1.8.0-amazon-corretto/ && ln -s  /usr/lib/jvm/java-1.8.0-amazon-corretto /usr/lib/jvm/java-8-openjdk-amd64
RUN ls -l /usr/lib/jvm/java-8-openjdk-amd64/
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ENV HADOOP_VERSION 2.7.4
ENV HADOOP_URL http://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

#COPY hadoop-$HADOOP_VERSION.tar.gz /tmp/hadoop.tar.gz
#COPY hadoop-$HADOOP_VERSION.tar.gz.asc /tmp/hadoop.tar.gz.asc
RUN wget -c http://dl.software.dc/dist/hadoop-2.7.4.tar.gz -O /tmp/hadoop.tar.gz
RUN wget -c http://dl.software.dc/dist/hadoop-2.7.4.tar.gz.asc -O /tmp/hadoop.tar.gz.asc

RUN set -x \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
RUN cp /etc/hadoop/mapred-site.xml.template /etc/hadoop/mapred-site.xml
RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

RUN mkdir /hadoop-data

ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1

ENV USER=root
ENV PATH $HADOOP_PREFIX/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

#Custom configuration goes here
ADD conf/capacity-scheduler.xml $HADOOP_CONF_DIR

ENTRYPOINT ["/entrypoint.sh"]
