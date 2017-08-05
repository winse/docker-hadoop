#!/bin/sh

if [[ $# < 1 ]] ; then 
  echo "Usage: $0 image.."
  exit 1
fi
IMAGES="$@"

DOWNLOAD_DIR=/tmp/docker-download
DOWNLOAD_DOCKER_SOCK_FILE=$DOWNLOAD_DIR/docker-download.sock
DOWNLOAD_DOCKER_SOCK=unix://$DOWNLOAD_DOCKER_SOCK_FILE
DOWNLOAD_DOCKER_PID=$DOWNLOAD_DIR/docker-download.pid

function finish {
  [ -f $DOWNLOAD_DOCKER_PID ] && kill "$(cat $DOWNLOAD_DOCKER_PID)" && sleep 3
  [ -e $DOWNLOAD_DIR ] && rm -rf $DOWNLOAD_DIR
}
trap finish EXIT

mkdir -p $DOWNLOAD_DIR

#--registry-mirror=https://us69kjun.mirror.aliyuncs.com \
docker daemon -H $DOWNLOAD_DOCKER_SOCK -p $DOWNLOAD_DOCKER_PID \
  --iptables=false \
  --ip-masq=false \
  --bridge=none \
  --graph=$DOWNLOAD_DIR/graph \
  --exec-root=$DOWNLOAD_DIR/root \
  --registry-mirror=https://docker.mirrors.ustc.edu.cn \
  2>$DOWNLOAD_DIR/docker-download.log 1> /dev/null &

while [ ! -S $DOWNLOAD_DOCKER_SOCK_FILE ] ; do 
  sleep 1;
done

for image in $IMAGES ; do
  docker -H $DOWNLOAD_DOCKER_SOCK pull $image
done
docker -H $DOWNLOAD_DOCKER_SOCK save $IMAGES | docker load


