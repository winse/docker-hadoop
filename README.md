# docker-hadoop

用于测试环境Centos7的部署。当前使用K8S来启动管理docker。

## 配置运行K8S

* 安装Docker-1.12

当前最新的版本是Docker-1.17-ce，但是配置文件有稍许变化，与修改参数脚本中不匹配。参考(官网文档](https://docs.docker.com/v1.12/engine/installation/linux/centos/)

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

下载K8S需要的镜像，然后导入tar打包的镜像：

链接：http://pan.baidu.com/s/1jIv9Z8q 密码：dt7t

各台物理机运行K8S Proxy，案例文档参考[Portable Multi-Node Cluster](https://kubernetes.io/docs/getting-started-guides/docker-multinode/)：

```
# cu3
cd kube-deploy/docker-multinode/
./master.sh

# others
cd kube-deploy/docker-multinode/
./worker.sh
```

系统后给node打标签，运行 kube-deploy/label.sh 脚本，通过hostname更好识别主机。

## 运行HADOOP

首选需要制作镜像，有参考网上的Dockerfile的写法。同时结合后面的yaml配置，使用ConfigMap的方式来部署配置和真正的运行脚本：

第一步： 下载JDK、HADOOP
第二步： 根据镜像的版本编译HADOOP

```
[root@cu2 hadoop]# ll build
total 181312
drwxr-xr-x 16 root root      4096 Apr  9 07:33 hadoop-2.6.5-src
drwx------  8 root root      4096 Apr  9 07:33 jdk1.8.0_121
-rw-r--r--  1 root root 183246769 Apr  5 10:11 jdk-8u121-linux-x64.tar.gz
drwx------ 10 root root      4096 Apr  9 07:33 protobuf-2.5.0
-rw-r--r--  1 root root   2401901 Jun 22  2014 protobuf-2.5.0.tar.gz
```

第三步： 制作镜像

```
./build.sh
```

然后运行部署HADOOP：

```
cd kube-deploy/hadoop/kubenetes/
./prepare.sh

kubectl create -f hadoop-master2.yaml
kubectl create -f hadoop-slaver.yaml 

kubectl scale --current-replicas=2 --replicas=4 -f hadoop-slaver.yaml 

./host.sh
```

如果操作的本机有显示器的话，就可以直接打开 hadoop-master2:50070 访问了。如果是远程机器的话，SSH连接时做一个socks5端口映射作为的代理即可本地访问。


## 待续
