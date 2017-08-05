#!/bin/sh
set -x 

export JAVA_URL="http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz"

BUILD_ROOT=build
DOCKER_CONF=docker

function downloadJDK(){

# [root@cu2 hadoop]# ll build
# total 181316
# lrwxrwxrwx  1 root root        28 Apr 19 12:11 hadoop-2.6.5-src -> /build/java/hadoop-2.6.5-src
# drwxr-xr-x  6 root root      4096 May 15 20:56 hbase-1.3.1
# lrwxrwxrwx  1 root root        51 May 15 20:57 hbase-1.3.1-bin.tar.gz -> /data/bigdata/share/download/hbase-1.3.1-bin.tar.gz
# drwxr-xr-x  8 root root      4096 Apr  9 07:33 jdk1.8.0_121
# -rwxr-xr-x  1 root root 183246769 Apr  5 10:11 jdk-8u121-linux-x64.tar.gz
# drwxr-xr-x 10 root root      4096 Apr  9 07:33 protobuf-2.5.0
# -rwxr-xr-x  1 root root   2401901 Jun 22  2014 protobuf-2.5.0.tar.gz
# lrwxrwxrwx  1 root root        26 Apr 20 09:52 zeppelin-0.7.1 -> /build/java/zeppelin-0.7.1
# drwxr-xr-x  8 cu   cu        4096 May 16 21:26 zookeeper-3.4.6


  # JDK
  #curl -sL --retry 3 --insecure --header "Cookie: oraclelicense=accept-securebackup-cookie;" "$JAVA_URL" | gunzip | tar x
  
  :

}

function build(){

  BUILD_DIR=$(mktemp -d)
  mkdir -p $BUILD_DIR
  trap "{ rm -rf $BUILD_DIR; exit 255; }" SIGINT
  
  if alias | grep cp >/dev/null ; then
    unalias cp
  fi
  cp -rf $DOCKER_CONF/java.Dockerfile $BUILD_DIR/Dockerfile
  cp -rf $BUILD_ROOT/jdk1.8.0_121 $BUILD_DIR
  
  docker build $BUILD_DIR -t cu.eshore.cn/library/java:jdk8
  docker push cu.eshore.cn/library/java:jdk8

}

downloadJDK
build

