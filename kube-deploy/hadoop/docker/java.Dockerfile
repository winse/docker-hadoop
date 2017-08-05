FROM centos:centos6

RUN yum install -y openssh-server which less rsync tar && \
    yum clean all

COPY jdk1.8.0_121 /usr/local/jdk1.8.0_121
RUN ln -s /usr/local/jdk1.8.0_121 /usr/local/jdk
ENV JAVA_HOME /usr/local/jdk1.8.0_121

WORKDIR /opt

