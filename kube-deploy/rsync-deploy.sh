#!/bin/sh

cd "$(dirname $0)"

SERVICES="$@"
HOSTS=$( cat hosts | awk '{print $2}' | grep -v -E '$\s*^' )

#########
# Harbor
if echo "$SERVICES" | grep harbor >/dev/null ; then 

  sed -i '/cu.eshore.cn/d' /etc/hosts

  cat >>/etc/hosts <<EOF
$( kubectl get service nginx -n default -o jsonpath="{..clusterIP}" ) cu.eshore.cn
EOF
  echo "Updated Local Hosts"

  for h in $HOSTS ; do
    if [[ $h != "$(hostname)" ]] ; then
      rsync -az /etc/hosts $h:/etc/
    fi

    ssh $h "mkdir -p /etc/docker/certs.d/cu.eshore.cn/"
    rsync -az /data/kubernetes/easy-rsa/easyrsa3/pki/ca.crt $h:/etc/docker/certs.d/cu.eshore.cn/

    ssh $h "docker login -u admin -p Harbor12345 cu.eshore.cn"
  done
  echo "Harbor Rsync Succeeded"

fi 

########
# Deploy
for h in $HOSTS ; do 
  
  if [[ $h != "$(hostname)" ]] ; then
    rsync -az $PWD/ $h:$PWD/ --exclude=backup --exclude=hadoop --exclude=".git" --delete
    rsync -az /etc/hosts $h:/etc/
  fi

# e.g. ExecStart=/usr/bin/dockerd --ip-masq=false --mtu=1472 --bip=10.1.24.1/24  
  ssh $h "
DOCKER_CONF=$( systemctl cat docker | head -1 | awk '{print $2}' )
if ! grep -- '--ip-masq' $DOCKER_CONF ; then sed 's@\(/usr/bin/dockerd\)@\1 --ip-masq=false @' $DOCKER_CONF ; fi

rm -f /etc/profile.d/k8s.sh
ln -s $PWD/k8s.profile /etc/profile.d/k8s.sh
  "

done
echo "Deploy Rsync Succeeded"
