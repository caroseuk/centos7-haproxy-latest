#!/bin/bash

cat << "EOF"
.---------------------------------.           
|  .---------------------------.  |           
|[]|                           |[]|           
|  |     Author: Chris Rose    |  |           
|  |                           |  |           
|  |                           |  |           
|  |          HAPROXY          |  |           
|  |         INSTALLER         |  |           
|  |       (From Source)       |  |           
|  |                           |  |           
|  |    github.com/caroseuk/   |  |           
|  `---------------------------'  |           
|      __________________ _____   |           
|     |   ___            |     |  |           
|     |  |   |           |     |  |           
|     |  |   |           |     |  |           
|     |  |   |           |     |  |           
|     |  |___|           |     |  |           
\_____|__________________|_____|__|
EOF

## Install pre-requisites if not already installed
echo "Installing pre-requisites if not already installed..."
yum install -y wget gcc pcre-static pcre-devel &> /dev/null

echo "Please enter the version of HA Proxy you would like to install (eg 1.7.4 or 1.8.4):"
read HAPVersion
shortHAPVersion="$(cut -d '.' -f 1 <<< "$HAPVersion")"."$(cut -d '.' -f 2 <<< "$HAPVersion")"

## Download the latest version of HA Proxy Source
wget http://www.haproxy.org/download/$shortHAPVersion/src/haproxy-$HAPVersion.tar.gz -O haproxy-$HAPVersion.tar.gz

## Uncompress the tar and remove downloaded archive
echo "Uncompressing tar archive..."
tar xzvf haproxy-$HAPVersion.tar.gz &> /dev/null
echo "Removing old tar archive"
rm haproxy-$HAPVersion.tar.gz &> /dev/null

## Navigate to newly created directory
cd haproxy-$HAPVersion

## Run MAKE on contents
echo "Building source, please wait..."
make TARGET=generic ARCH=native CPU=$(uname -m) -j8 &> /dev/null

## Install newly compiled source
echo "Installing HA Proxy..."
make install PREFIX=/usr

## Copy HAProxy example init.d file to /etc/init.d/haproxy
cp ~/haproxy-$HAPVersion/examples/haproxy.init /etc/init.d/haproxy 
chmod 755 /etc/init.d/haproxy

## Create directories (and subdirectories) and files required for HA Proxy
mkdir -p /etc/haproxy
mkdir -p /run/haproxy
mkdir -p /var/lib/haproxy
touch /var/lib/haproxy/stats
cp ~/haproxy-$HAPVersion/examples/content-sw-sample.cfg /etc/haproxy/haproxy.cfg

## Create new user for HAProxy to run as
useradd -r haproxy

## Reload system daemon to recognize newly created HAproxy init.d file
systemctl daemon-reload

echo "HA Proxy $HAPVersion Installed and example configuration copied, you may now configure and start HA Proxy."
echo "systemctl start haproxy"
