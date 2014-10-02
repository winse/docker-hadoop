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

#### 运行测试命令

```
[root@docker ~]# docker run -d --name master -h master hadoop 

[root@docker ~]# echo `docker inspect -f '{{.NetworkSettings.IPAddress}}' master` master >> /etc/hosts
[root@docker ~]# ssh-copy-id hadoop@master
[root@docker ~]# ssh hadoop@master

  [hadoop@master ~]$ cd /opt/hadoop-2.5.1/

  [hadoop@master hadoop-2.5.1]$ ssh-copy-id master
  [hadoop@master hadoop-2.5.1]$ ssh-copy-id localhost
  
  [hadoop@master hadoop-2.5.1]$ bin/hadoop namenode -format
  [hadoop@master hadoop-2.5.1]$ sbin/start-dfs.sh 
  [hadoop@master hadoop-2.5.1]$ jps
  263 DataNode
  182 NameNode
  467 Jps
  [hadoop@master hadoop-2.5.1]$ sbin/start-yarn.sh 
  [hadoop@master hadoop-2.5.1]$ jps
  595 NodeManager
  511 ResourceManager
  630 Jps
  263 DataNode
  182 NameNode 
```

如果你为ssh访问添加了隧道，还可以直接在windows本地通过浏览器访问web页面：

![Web View](https://cloud.githubusercontent.com/assets/667902/4495346/af4cbbf4-4a5a-11e4-9621-8a6c5d1a3a3a.png)
