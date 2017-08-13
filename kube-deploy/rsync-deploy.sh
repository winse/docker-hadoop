#!/bin/sh

cd "$(dirname $0)"

HOSTS=$( cat hosts | awk '{print $2}' | grep -v -E '$\s*^' )

########
# Deploy
for h in $HOSTS ; do 
  
  if [[ $h != "$(hostname)" ]] ; then
    rsync -az $PWD/ $h:$PWD/ --exclude=backup --exclude=hadoop --exclude=".git" --delete
    rsync -az /etc/hosts $h:/etc/
    rsync -az /etc/yum.repos.d/dta.repo $h:/etc/yum.repos.d/
  fi

  ssh $h "
rm -f /etc/profile.d/k8s.sh
ln -s $PWD/k8s.profile /etc/profile.d/k8s.sh
  "

done
echo "Deploy Rsync Succeeded"
