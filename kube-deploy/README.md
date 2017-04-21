## kube-deploy

记录测试环境的实际使用中一些脚本和容器的yaml。

1. docker-pull

由于内网搭建了harbor作为私服，所以下载外部的镜像比较麻烦，从hub.docker.com上面拉镜像很慢。所以写了一个方法，启动一个单独的临时dockerd进程用来下载镜像，save后load到当前实际运行的docker。

```
docker-pull tomcat:7-jre7 tomcat:8.0-jre8 
```

