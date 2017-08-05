FROM cu.eshore.cn/library/java:jdk8

RUN rm -rf /etc/localtime && \
  ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY hadoop.limits /etc/security/limits.d/hadoop.conf

#
# COPY hadoop-2.6.5 /opt/hadoop-2.6.5
#

RUN groupadd hadoop && useradd -m -g hadoop hadoop
RUN mkdir /data && chmod 700 /data && chown hadoop:hadoop /data
RUN chown hadoop:hadoop /opt

RUN echo 'hadoop:hadoop' |chpasswd

WORKDIR /opt
CMD ["/usr/sbin/sshd", "-D"]
