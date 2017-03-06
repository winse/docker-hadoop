ARCH=amd64
DEFAULT_IP_ADDRESS=$(ip -o -4 addr list $(ip -o -4 route show to default | awk '{print $5}' | head -1) | awk '{print $4}' | cut -d/ -f1 | head -1)
IP_ADDRESS=${IP_ADDRESS:-${DEFAULT_IP_ADDRESS}}

sed -e "s/ARCH/${ARCH}/g;" -e "s|MASTER_IP|${IP_ADDRESS}|g"  skydns.yaml | kubectl create -f -

