#!/bin/bash

## Ensure your system is up to date
# yum update -y
## Reboot if needed (eg new Kernel)
# reboot

echo ""
echo ""
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
echo ""
echo "  HA Proxy From Source Installer"
echo ""
echo ""
echo "  Written by Chris Rose (2018)"
echo "  https://github.com/caroseuk/"
echo ""
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
echo ""
echo ""
echo ""
echo ""

## Install pre-requisites if not already installed
echo "Installing pre-requisites if not already installed..."
yum install -y wget gcc pcre-static pcre-devel

echo "Please enter the version of HA Proxy you would like to install (eg 1.7.4 or 1.8.4):"
read HAPVersion
## Download the latest version of HA Proxy Source
wget http://www.haproxy.org/download/1.8/src/haproxy-$HAPVersion.tar.gz -O haproxy.tar.gz

## Uncompress the tar
tar xzvf haproxy.tar.gz

## Navigate to newly created directory
cd haproxy-$HAPVersion

## Run MAKE on contents
make TARGET=generic ARCH=native CPU=x86_64 -j8

## Install newly compiled source
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
