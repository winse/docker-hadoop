#!/bin/bash

# Copyright 2015 The Kubernetes Authors All rights reserved.
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

# empty args will stop and delete bootstrap containers.
KUBE_RESET=${1:-"ALL"}

kube::multinode::main

# Turndown kubernetes in docker
if [[ ${KUBE_RESET} == "ALL" ]] ; then
  kube::multinode::turndown
else
  kube::multinode::turndown::main
fi

kube::log::status "Done."
