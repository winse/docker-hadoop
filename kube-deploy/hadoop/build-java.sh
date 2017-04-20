#!/bin/sh
set -x 

export JAVA_URL="http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz"

BUILD_ROOT=build
DOCKER_CONF=docker

function downloadJDK(){

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

