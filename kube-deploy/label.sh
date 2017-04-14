#!/bin/sh

cd "$(dirname $0)"

cat hosts | grep -v -E '$\s*^' | awk '{print "kubectl label nodes "$1" hostname="$2}' | while read line ; do sh -c "$line" ; done

