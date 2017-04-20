alias docker-bs='docker -H unix:///var/run/docker-bootstrap.sock'

export K8S_VERSION=v1.5.6
export KUBECONFIG=/var/lib/kubelet/kubeconfig/kubeconfig.yaml
export PATH=/data/kubernetes/kube-deploy/docker-multinode:$PATH

export MASTER_IP=cu3

export HADOOP_DEPLOY=/data/kubernetes/kube-deploy/hadoop/
