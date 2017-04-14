#!/bin/sh

# 
# docker exec -ti dev bash
# 

JAVA_URL="http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz"
HADOOP_URL="http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.6.5/hadoop-2.6.5-src.tar.gz"
PROTO_URL="https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz"

BUILD_ROOT=build
DOCKER_ROOT=docker

function buildJDK(){

  # JDK
  #curl -sL --retry 3 --insecure --header "Cookie: oraclelicense=accept-securebackup-cookie;" "$JAVA_URL" | gunzip | tar x
  
  :

}

function buildHadoop(){
  
  # HADOOP
  #curl -sL --retry 3 --insecure "$PROTO_URL"  | gunzip | tar x 
  #curl -sL --retry 3 --insecure "$HADOOP_URL" | gunzip | tar x
  
  ( cd $BUILD_ROOT/protobuf-2.5.0 ; ./configure && make && make install )
  ( cd $BUILD_ROOT/hadoop-2.6.5-src ; mvn clean package -Pdist,native -Dmaven.javadoc.skip=true -DskipTests )
     
}

function buildDocker(){

  BUILD_DIR=$(mktemp -d)
  mkdir -p $BUILD_DIR
  trap "{ rm -rf $BUILD_DIR; exit 255; }" SIGINT
  
  if alias | grep cp >/dev/null ; then
    unalias cp
  fi
  cp -rf $DOCKER_ROOT/* $BUILD_DIR
  cp -rf $BUILD_ROOT/jdk1.8.0_121 $BUILD_ROOT/hadoop-2.6.5-src/hadoop-dist/target/hadoop-2.6.5 $BUILD_DIR
  
  docker build $BUILD_DIR -t cu.eshore.cn/library/hadoop:root7
#  docker push cu.eshore.cn/library/hadoop:root7

}

#buildHadoop
#buildJDK
buildDocker
