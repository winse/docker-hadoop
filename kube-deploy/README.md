## kube-deploy

记录测试环境的实际使用中一些脚本和容器的yaml。

#### 小工具

1. pod_bash

`kubectl exec -ti PODNAME bash` 能登陆到对应的容器，但是这种方式进入的窗口大小有点问题（好像行只有80字符）。ssh_pod通过获取对应的NODE的ip和容器的id进行登录。

```
./ssh_pod PODNAME NAMESPACE
```

2. docker-download-mirror.sh

由于内网搭建了harbor作为私服，所以下载外部的镜像比较麻烦，从hub.docker.com上面拉镜像很慢。所以写了一个方法，启动一个单独的临时dockerd进程用来下载镜像，save后load到当前实际运行的docker。

```
./docker-download-mirror.sh tomcat:7-jre7 tomcat:8.0-jre8
```


#### 部署脚本

把所有需要执行的命令写到一个脚本，方便反反复复的测试。

0. k8s.profile

把常用的配置写入到该文件，通过 rsync-deploy.sh 脚本把文件同步到各台物理机。把profile文件做一个软链到 /etc/profile.d/ 。

1. test-hadoop.k8s NAMESPACE

通过手动同步程序的进行部署。用着效果还行，也算一键部署了。但就是master/slaver关掉还没有好的解决方案。

使用ConfigMaps进行部署，部署后就不能修改了（在容器内修改配置没效果，会被替换），这种方式对于配置优化积极性打击太大了。

99. hadoop_k8s NAMESPACE

把配置文件写入到ConfigMaps配置文件，然后执行使用 kubectl apply 部署（one master，two slavers），最后把部署的节点的ip和域名写入到当前操作主机，方便后面通过socks5代理访问查看网页。


999. harbor_k8s (测试环境性能不咋的，连接好像有那么点问题。手动拷贝镜像！类似hosts...)

按顺序部署所有的配置，然后把CA拷贝到各台物理机器的对应的目录下，同时把harbor需要使用的域名写入/etc/hosts，最后登录docker。后面就可以直接pull、push操作了。
