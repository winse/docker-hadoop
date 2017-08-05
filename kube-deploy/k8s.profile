alias docker-bs='docker -H unix:///var/run/docker-bootstrap.sock'
alias cd-kuby='cd /data/kubernetes/kube-deploy'
alias pods='kubectl get pods --all-namespaces -o wide'

export K8S_VERSION=v1.5.6
export MASTER_IP=cu3

export KUBECONFIG=/var/lib/kubelet/kubeconfig/kubeconfig.yaml
export PATH=/data/kubernetes/kube-deploy/docker-multinode:$PATH

export HADOOP_DEPLOY=/data/kubernetes/kube-deploy/hadoop/
