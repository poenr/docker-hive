FROM harbor.software.dc/mpdata/hadoop-base:2.0.0-hadoop2.7.4-java8
LABEL  maintainer="凌久高科软件开发中心 <rjkfzx@linjo.cn>"

HEALTHCHECK CMD curl -f http://localhost:8088/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8088

CMD ["/run.sh"]
