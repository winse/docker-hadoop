# docker-hadoop

用于测试环境Centos7的部署。当前使用K8S来启动管理docker。

## 配置运行K8S

* 安装Docker-1.12

当前最新的版本是Docker-v17.06，但是K8S官网适配推荐使用v1.12。参考(官网文档](https://docs.docker.com/v1.12/engine/installation/linux/centos/)

```
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

yum install docker-engine-1.12.6 docker-engine-selinux-1.12.6 -y
```

安装好docker后，启动docker。如果可以的话把 /var/lib/docker 转移到大的磁盘，然后做一个软链接回来。

* 安装K8S

检出当前项目，进入 kube-deploy。给需要部署的机器安装deploy ：

```
cat >hosts <<EOF
192.168.0.1 cu1
192.168.0.2 cu2
192.168.0.3 cu3
EOF

vi k8s.profile
  MASTER_IP=cu3

./rsync-deploy.sh
```

下载K8S需要的RPM和镜像，然后导入tar打包的镜像：

链接：http://pan.baidu.com/s/1hrRs5MW

各台物理机运行K8S Proxy，文档参考[Using kubeadm to Create a Cluster](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm)：

```
docker load <kubeadm.tar
yum install -y kubelet kubeadm

systemctl enable kubelet
systemctl start kubelet 

## master
kubeadm init --skip-preflight-checks --pod-network-cidr=10.244.0.0/16 --kubernetes-version=v1.7.2 

kubectl apply -f kube-flannel.yml 
kubectl apply -f kube-flannel-rbac.yml 

## worker
kubeadm join --token ad430d.beff5be4b98dceec 192.168.0.148:6443 --skip-preflight-checks

上面的命令会卡住，不要关。新开一个窗口
sed -i 's/KUBELET_CGROUP_ARGS=--cgroup-driver=systemd/KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf 
sed -i 's#/usr/bin/dockerd.*#/usr/bin/dockerd --ip-masq=false#' /usr/lib/systemd/system/docker.service 

systemctl daemon-reload; systemctl restart docker kubelet 

等一会，kubeadm就运行成功了。
```

然后部署监控的dashboard和heapster

```
kubectl apply -f heapster/influxdb/
kubectl apply -f heapster/rbac/
kubectl apply -f kubernetes-dashboard.yaml 

```

## 部署私有仓库Harbor

安装部署使用脚本是可以的。但测试环境就几台机器，发现维护一个Harbor成本有些高，现在手动更新。

```
kube-deploy/easy-rsa.sh 

vi kube-deploy/harbor-make/harbor.cfg
hostname = DOMAIN
ui_url_protocol = https
ssl_cert = crt PATH
ssl_cert_key = key PATH

# 把yaml里面的配置修改成你本地对应的镜像名
find kubernetes/ -name "*.rc.yaml" 
kubernetes/nginx/nginx.rc.yaml
kubernetes/mysql/mysql.rc.yaml
kubernetes/registry/registry.rc.yaml
kubernetes/ui/ui.rc.yaml
kubernetes/jobservice/jobservice.rc.yaml

kube-deploy/harbor_k8s
```

## 编译部署HADOOP

首选需要制作镜像，有参考网上的Dockerfile的写法。同时结合后面的yaml配置，使用ConfigMap的方式来部署配置和真正的运行脚本：

第一步： 下载JDK、HADOOP

第二步： 根据镜像的版本编译HADOOP

```
[root@cu2 hadoop]# ll build
total 181316
lrwxrwxrwx  1 root root        28 Apr 19 12:11 hadoop-2.6.5-src -> /build/java/hadoop-2.6.5-src
drwxr-xr-x  6 root root      4096 May 15 20:56 hbase-1.3.1
drwxr-xr-x  8 root root      4096 Apr  9 07:33 jdk1.8.0_121
-rwxr-xr-x  1 root root 183246769 Apr  5 10:11 jdk-8u121-linux-x64.tar.gz
drwxr-xr-x 10 root root      4096 Apr  9 07:33 protobuf-2.5.0
-rwxr-xr-x  1 root root   2401901 Jun 22  2014 protobuf-2.5.0.tar.gz
lrwxrwxrwx  1 root root        26 Apr 20 09:52 zeppelin-0.7.1 -> /build/java/zeppelin-0.7.1
drwxr-xr-x  8 cu   cu        4096 May 16 21:26 zookeeper-3.4.6
```

第三步： 制作镜像

```
./build-java.sh
./build-hadoop.sh
```

然后运行部署HADOOP：

```
cd kube-deploy/hadoop/kubenetes/

kubectl create -f simple-hadoop.yaml

# kubectl scale --current-replicas=2 --replicas=4 -f hadoop-slaver.yaml 
```

然后使用脚本把HOST主机上面的hadoop/hbase/hive拷贝到对应的机器，然后远程运行（脚本写的有些粗糙，暂时没提交）。

如果操作的本机有显示器的话，就可以直接打开 hadoop-master2:50070 访问了。如果是远程机器的话，SSH连接时做一个socks5端口映射作为的代理即可本地访问。


## 待续
