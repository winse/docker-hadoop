#!/bin/sh

sed -i '/# K8S HADOOP/,/# @K8S HADOOP/d' /etc/hosts

cat >>/etc/hosts <<EOF
# K8S HADOOP
$( kubectl get pods -o wide --show-labels=true | grep "cluster=dta" | awk '{print $6" "$1}' )
# @K8S HADOOP
EOF

