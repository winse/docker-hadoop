#!/bin/sh

K8S_CONFIG_DIR=$(pwd)
cd ../config

function setting(){
cd hadoop

echo "
  hadoop-env.sh: |
$( cat hadoop-env.sh | sed 's/^/    /' )
$( cat ../hadoop.cfg | sed 's/^/    /' )
"

ls | grep -v 'hadoop-env.sh' | while read file; do  
  echo "
  ${file}: |
$( cat $file | sed 's/^/    /' )
"
done
}

function etc(){
cd etc

ls | while read file; do  
  echo "
  ${file}: |
$( cat $file | sed 's/^/    /' )
"
done
}

cat >$K8S_CONFIG_DIR/hadoop.cm.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: dta-hadoop-config
data:
$( setting )
EOF


cat >$K8S_CONFIG_DIR/bin.cm.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: dta-bin-config
data:
$( etc )
EOF

kubectl apply -f $K8S_CONFIG_DIR/hadoop.cm.yaml
kubectl apply -f $K8S_CONFIG_DIR/bin.cm.yaml
