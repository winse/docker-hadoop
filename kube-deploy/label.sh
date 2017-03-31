cat /etc/hosts | grep -E "\scu[0-9]" | awk '{print "kubectl label nodes "$1" hostname="$2}' | while read line ; do sh -c "$line" ; done

