#!/bin/sh

HADOOP_URL="http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.6.5/hadoop-2.6.5-src.tar.gz"
PROTO_URL="https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz"

BUILD_ROOT=build
DOCKER_ROOT=docker

function buildDocker(){

  BUILD_DIR=$(mktemp -d)
  mkdir -p $BUILD_DIR
  trap "{ rm -rf $BUILD_DIR; exit 255; }" SIGINT
  
  if alias | grep cp >/dev/null ; then
    unalias cp
  fi
  # build: https://gist.github.com/winse/c0012a743b354eafbbcf8d92cc68d8e6
  cp -rf $DOCKER_ROOT/zeppelin.Dockerfile $BUILD_DIR/Dockerfile
  cp -rf $BUILD_ROOT/zeppelin-0.7.1/zeppelin-distribution/target/zeppelin-0.7.1/zeppelin-0.7.1 $BUILD_DIR
  
  ls -l $BUILD_DIR
  docker build $BUILD_DIR -t cu.eshore.cn/library/zeppelin:0.7.1
  docker push cu.eshore.cn/library/zeppelin:0.7.1

}

buildDocker
