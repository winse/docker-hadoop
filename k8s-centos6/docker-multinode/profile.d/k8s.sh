
## K8s
export POD_COL="custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[*].restartCount,CONTAINERS:.spec.containers[*].name,IP:.status.podIP,HOST:.spec.nodeName"
export KUBECONFIG=/var/lib/kubelet/kubeconfig/kubeconfig.yaml
export PATH=/data/kubernetes/docker-multinode:$PATH

