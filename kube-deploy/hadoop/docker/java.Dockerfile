FROM centos:centos6

RUN yum install -y openssh-server which less rsync tar && \
    yum clean all

COPY jdk1.8.0_121 /opt/jdk1.8.0_121
ENV JAVA_HOME /opt/jdk1.8.0_121

WORKDIR /opt

