#!/bin/sh

# cd /data/kubernetes
cd ..

git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3

echo "
#######################
# ======  CA  ======= #  
"

./easyrsa init-pki
./easyrsa build-ca #记住输入的密码，下面颁发证书还会用到

echo "
#######################
# ======  CERT  ======= #  
"

./easyrsa gen-req cu nopass
./easyrsa sign-req server cu #commonName填将要用到的域名咯

