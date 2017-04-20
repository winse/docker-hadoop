FROM cu.eshore.cn/library/java:jdk8

COPY hadoop-2.6.5 /opt/hadoop-2.6.5
COPY gosu-amd64 /usr/bin/gosu

RUN groupadd -r hadoop && \
    useradd -r -g hadoop hadoop && \
    mkdir -p /data/bigdata && \
    chmod 700 /data && \
    chmod 700 /data/bigdata && \
    chown -R hadoop:hadoop /data && \
    chown -R hadoop:hadoop /opt/hadoop-2.6.5 && \
    chmod +x /usr/bin/gosu  

WORKDIR /opt/hadoop-2.6.5


