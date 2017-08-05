#!/bin/sh

HADOOP_URL="http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.6.5/hadoop-2.6.5-src.tar.gz"
PROTO_URL="https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz"

BUILD_ROOT=build
DOCKER_ROOT=docker

function buildHadoop(){
  
  # 
  # docker exec -ti dev bash
  # 

  # HADOOP
  #curl -sL --retry 3 --insecure "$PROTO_URL"  | gunzip | tar x 
  # snappy
  # 
  #curl -sL --retry 3 --insecure "$HADOOP_URL" | gunzip | tar x
  
  ( cd $BUILD_ROOT/protobuf-2.5.0 ; ./configure && make && make install )
  # ( cd $BUILD_ROOT/hadoop-2.6.5-src ; mvn clean package -Pdist,native -Dmaven.javadoc.skip=true -DskipTests )
  ( cd $BUILD_ROOT/hadoop-2.6.5-src ; mvn clean package -Pdist,native -Dmaven.javadoc.skip=true -DskipTests -Drequire.snappy=true -Dbundle.snappy=true -Dsnappy.lib=/usr/local/lib )
     
}

function buildDocker(){

  IMAGE="cu.eshore.cn/library/hadoop:2.6.5"
  
  pdsh -w cu[1-5] docker rmi -f "$IMAGE"

  BUILD_DIR=$(mktemp -d)
  mkdir -p $BUILD_DIR
  trap "{ rm -rf $BUILD_DIR; exit 255; }" SIGINT
  
  if alias | grep cp >/dev/null ; then
    unalias cp
  fi
#  cp -rf $DOCKER_ROOT/gosu-amd64 $BUILD_DIR
  cp -rf $DOCKER_ROOT/hadoop.limits $BUILD_DIR
  cp -rf $DOCKER_ROOT/hadoop.Dockerfile $BUILD_DIR/Dockerfile
#  cp -rf $BUILD_ROOT/hadoop-2.6.5-src/hadoop-dist/target/hadoop-2.6.5 $BUILD_DIR
  
  ls -l $BUILD_DIR
  docker build $BUILD_DIR -t "$IMAGE"
  docker push "$IMAGE"

}

#buildHadoop
buildDocker
