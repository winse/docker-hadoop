FROM cu.eshore.cn/library/java:jdk8

COPY zeppelin-0.7.1 /opt/zeppelin-0.7.1

RUN groupadd -r hadoop && \
    useradd -r -g hadoop hadoop && \
    mkdir -p /data/bigdata && \
    chmod 700 /data && \
    chmod 700 /data/bigdata && \
    chown -R hadoop:hadoop /data && \
    chown -R hadoop:hadoop /opt/zeppelin-0.7.1 

WORKDIR /opt/zeppelin-0.7.1


