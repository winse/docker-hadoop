Docker-Hadoop
=============

#### 安装Docker Centos6

```
yum install epel-release
yum install docker-io

service docker start
```

#### 生成Docker-Hadoop

```
git clone https://github.com/winse/docker-hadoop.git
cd docker-hadoop
# 在Dockerfile中使用了本地jdk和hadoop文件！
docker build -t hadoop .
```

#### 常用命令

```
[root@docker ~]# docker run -d --name master -h master hadoop 

[root@docker ~]# echo `docker inspect -f '{{.NetworkSettings.IPAddress}}' master` master >> /etc/hosts
[root@docker ~]# ssh-copy-id hadoop@master
[root@docker ~]# ssh hadoop@master

  [hadoop@master hadoop-2.5.1]$ ssh-copy-id master
  [hadoop@master hadoop-2.5.1]$ ssh-copy-id localhost

```
