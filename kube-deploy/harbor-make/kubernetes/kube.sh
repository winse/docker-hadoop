#!/bin/sh

OP=${1:-"apply"}

######################################
# create containers

kubectl $OP -f pv/

kubectl $OP -f jobservice/jobservice.cm.yaml
kubectl $OP -f mysql/mysql.cm.yaml
kubectl $OP -f nginx/nginx.cm.yaml
kubectl $OP -f registry/registry.cm.yaml
kubectl $OP -f ui/ui.cm.yaml

kubectl $OP -f jobservice/jobservice.svc.yaml
kubectl $OP -f mysql/mysql.svc.yaml
kubectl $OP -f nginx/nginx.svc.yaml
kubectl $OP -f registry/registry.svc.yaml
kubectl $OP -f ui/ui.svc.yaml

for rc in registry/registry.rc.yaml mysql/mysql.rc.yaml jobservice/jobservice.rc.yaml ui/ui.rc.yaml nginx/nginx.rc.yaml ; do

if ! grep imagePullPolicy $rc >/dev/null ; then
  sed '/image:/i        imagePullPolicy: IfNotPresent' $rc
fi

kubectl $OP -f $rc

done
