#!/bin/bash

if [[ "$1" != "inline" ]] ; then
  # Source common.sh
  source $(dirname "${BASH_SOURCE}")/common.sh
  
  # Set MASTER_IP to localhost when deploying a master
  MASTER_IP=localhost
  
  kube::multinode::main
  
  kube::multinode::log_variables
fi

# If under v1.3.0, run the proxy
if [[ $((VERSION_MINOR < 3)) == 1 ]]; then
  kube::multinode::start_k8s_master_addon
fi
