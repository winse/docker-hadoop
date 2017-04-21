alias docker-bs='docker -H unix:///var/run/docker-bootstrap.sock'
alias cd-kuby='cd /data/kubernetes/kube-deploy'
alias kubectl-pods='kubectl get pods --all-namespaces -o wide'

export K8S_VERSION=v1.5.6
export MASTER_IP=cu3

export KUBECONFIG=/var/lib/kubelet/kubeconfig/kubeconfig.yaml
export PATH=/data/kubernetes/kube-deploy/docker-multinode:$PATH

export HADOOP_DEPLOY=/data/kubernetes/kube-deploy/hadoop/

function docker-pull () {
  local images="$@"

  local DOWNLOAD_DIR=/tmp/docker-download
  local DOWNLOAD_DOCKER_SOCK_FILE=$DOWNLOAD_DIR/docker-download.sock
  local DOWNLOAD_DOCKER_SOCK=unix://$DOWNLOAD_DOCKER_SOCK_FILE
  local DOWNLOAD_DOCKER_PID=$DOWNLOAD_DIR/docker-download.pid

  mkdir -p $DOWNLOAD_DIR

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

  for image in $images ; do
    docker -H $DOWNLOAD_DOCKER_SOCK pull $image
  done
  docker -H $DOWNLOAD_DOCKER_SOCK save $images | docker load

  [ ! -z $DOWNLOAD_DOCKER_PID ] && kill $(cat $DOWNLOAD_DOCKER_PID) && sleep 4 && rm -rf $DOWNLOAD_DIR

} 

