文档参考： <https://kubernetes.io/docs/getting-started-guides/docker-multinode/>

1. 下载镜像

```
[root@cu2 ~]# docker images
REPOSITORY                                            TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
gcr.io/google_containers/heapster-grafana-amd64       v4.0.2              74d2c72849cc        6 weeks ago         131.5 MB
gcr.io/google_containers/heapster-influxdb-amd64      v1.1.1              55d63942e2eb        6 weeks ago         11.59 MB
gcr.io/google_containers/heapster-amd64               v1.3.0-beta.1       026fb02eca65        6 weeks ago         101.3 MB
gcr.io/google_containers/kubernetes-dashboard-amd64   v1.5.1              9af7d5c61ccf        8 weeks ago         103.6 MB
gcr.io/google_containers/hyperkube-amd64              v1.2.7              1dd7250ed1b3        4 months ago        231.4 MB
quay.io/coreos/flannel                                v0.6.1-amd64        ef86f3a53de0        6 months ago        27.89 MB
gcr.io/google_containers/etcd-amd64                   3.0.4               ef5e89d609f1        7 months ago        39.62 MB
gcr.io/google_containers/kube2sky-amd64               1.15                f93305484d65        10 months ago       29.16 MB
gcr.io/google_containers/etcd-amd64                   2.2.5               a6752fb962b5        11 months ago       30.45 MB
gcr.io/google_containers/skydns-amd64                 1.0                 a925f95d080a        11 months ago       15.57 MB
gcr.io/google_containers/exechealthz-amd64            1.0                 5b9ac190b20c        11 months ago       7.116 MB
gcr.io/google_containers/pause                        2.0                 9981ca1bbdb5        17 months ago       350.2 kB
```

2. 下载kubectl-v1.2.7

3. Master

```
./master.sh

测试效果

curl -fsSL http://localhost:2379/health
curl -s http://localhost:8080/healthz
curl -s http://localhost:8080/api
kubectl get pods
```

4. Worker

```
MASTER_IP=cu2 ./worker.sh
```
