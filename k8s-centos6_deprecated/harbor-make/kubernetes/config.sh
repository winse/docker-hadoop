#!/bin/sh

######################################
# fix container config

mkdir /tmp/config 
cd /tmp/config 

# kubectl get pods --show-labels
TEMP=$( mktemp -d harbor_XXXX )
cd $TEMP

for name in registry ui jobservice nginx ; do
    uid=$( kubectl get pods -l name=$name-apps -o jsonpath={..metadata.uid} )
    nodeName=$( kubectl get pods -l name=$name-apps -o jsonpath={..spec.nodeName} )

set -x 
    case "$name" in
    registry ) 
    kubectl get configmap harbor-registry-config -o jsonpath={.data.config} >config.yml
    kubectl get configmap harbor-registry-config -o jsonpath={.data.cert} >root.crt
    ;;
    ui ) 
    kubectl get configmap harbor-ui-config -o jsonpath={.data.config} >app.conf
    kubectl get configmap harbor-ui-config -o jsonpath={.data.pkey} >private_key.pem
    ;;
    jobservice ) 
    kubectl get configmap harbor-jobservice-config -o jsonpath={.data.config} >app.conf
    ;;
    nginx ) 
    kubectl get configmap harbor-nginx-config -o jsonpath={.data.config} >nginx.conf
    kubectl get configmap harbor-nginx-config -o jsonpath={.data.pkey} >https.key
    kubectl get configmap harbor-nginx-config -o jsonpath={.data.cert} >https.crt
    ;;
    * ) echo "Input Error!" ;;
    esac

    scp * ${nodeName}:/var/lib/kubelet/pods/${uid}/volumes/kubernetes.io~configmap/config 
set +x
    rm -f *

done

rm -rf /tmp/config
