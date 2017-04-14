FROM centos:centos7

RUN yum install -y openssh-server which less rsync tar && \
    yum clean all

COPY jdk1.8.0_121 /opt/jdk1.8.0_121
COPY hadoop-2.6.5 /opt/hadoop-2.6.5
COPY gosu-amd64 /usr/bin/gosu

RUN groupadd -r hadoop && \
    useradd -r -g hadoop hadoop

RUN mkdir -p /data/bigdata && \
    chmod 700 /data && \
    chmod 700 /data/bigdata && \
    chown -R hadoop:hadoop /data && \
    chown -R hadoop:hadoop /opt/hadoop-2.6.5 && \
    chmod +x /usr/bin/gosu  

WORKDIR /opt


