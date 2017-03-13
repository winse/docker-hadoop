#!/bin/sh

######################################
# create containers

kubectl apply -f pv/

kubectl apply -f jobservice/jobservice.cm.yaml
kubectl apply -f mysql/mysql.cm.yaml
kubectl apply -f nginx/nginx.cm.yaml
kubectl apply -f registry/registry.cm.yaml
kubectl apply -f ui/ui.cm.yaml

kubectl apply -f jobservice/jobservice.svc.yaml
kubectl apply -f mysql/mysql.svc.yaml
kubectl apply -f nginx/nginx.svc.yaml
kubectl apply -f registry/registry.svc.yaml
kubectl apply -f ui/ui.svc.yaml

kubectl apply -f registry/registry.rc.yaml
kubectl apply -f mysql/mysql.rc.yaml
kubectl apply -f jobservice/jobservice.rc.yaml
kubectl apply -f ui/ui.rc.yaml
kubectl apply -f nginx/nginx.rc.yaml

