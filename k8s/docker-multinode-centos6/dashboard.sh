#!/bin/bash

# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Source common.sh
source $(dirname "${BASH_SOURCE}")/common.sh

# Set MASTER_IP to localhost when deploying a master
MASTER_IP=localhost

kube::multinode::main

kube::multinode::log_variables

# If under v1.3.0, run the proxy
if [[ $((VERSION_MINOR < 3)) == 1 ]]; then
  if ! kubectl get ns | grep kube-system ; then
    kubectl create namespace kube-system
  fi
  kube::multinode::start_k8s_master_dashboard
fi
