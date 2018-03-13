#!/bin/bash
echo ""
echo ""
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
echo ""
echo ""
echo ""
## Settings
etcdir=/etc/haproxy
rundir=/run/haproxy
varlibdir=/var/lib/haproxy
statsfile=/var/lib/haproxy/stats
haproxyconffile=/etc/haproxy/haproxy.cfg

## Install pre-requisites if not already installed
echo "Installing pre-requisites if not already installed..."
yum install -y wget gcc pcre-static pcre-devel &> /dev/null
echo ""

echo "Please enter the version of HA Proxy you would like to install (eg 1.7.4 or 1.8.4):"
read HAPVersion
shortHAPVersion="$(cut -d '.' -f 1 <<< "$HAPVersion")"."$(cut -d '.' -f 2 <<< "$HAPVersion")"

## Download the latest version of HA Proxy Source
echo "Downloading haproxy-$HAPVersion.tar.gz from HAProxy..."
wget http://www.haproxy.org/download/$shortHAPVersion/src/haproxy-$HAPVersion.tar.gz -O haproxy-$HAPVersion.tar.gz &> /dev/null
echo ""

## Uncompress the tar and remove downloaded archive
echo "* Uncompressing tar archive..."
tar xzvf haproxy-$HAPVersion.tar.gz &> /dev/null
echo ""
echo "* Removing old tar archive..."
rm haproxy-$HAPVersion.tar.gz &> /dev/null
echo ""

## Navigate to newly created directory
cd haproxy-$HAPVersion

## Run MAKE on contents
echo "* Building source, please wait..."
make TARGET=generic ARCH=native CPU=$(uname -m) -j8 &> /dev/null
echo ""

## Install newly compiled source
echo "* Installing HAProxy $HAPVersion ..."
make install PREFIX=/usr &> /dev/null
echo ""

## Copy HAProxy example init.d file to /etc/init.d/haproxy
echo "* Creating Init Scripts..."
cp ~/haproxy-$HAPVersion/examples/haproxy.init /etc/init.d/haproxy 
chmod 755 /etc/init.d/haproxy
echo ""

## Check for pre-existing directories/files and create if needed
    if [ ! -d "$etcdir" ]
    then
        mkdir -p /etc/haproxy
    else
        echo "/etc/haproxy directory already exists.. skipping..."
    fi

    if [ ! -d "$rundir" ]
    then
        mkdir -p /run/haproxy
    else
        echo "/run/haproxy directory already exists.. skipping..."
    fi

    if [ ! -d "$varlibdir" ]
    then
        mkdir -p /var/lib/haproxy
    else
        echo "/var/lib/haproxy directory already exists.. skipping..."
    fi

    if [ ! -f "$statsfile" ]
    then
        touch /var/lib/haproxy/stats
    else
        echo "/var/lib/haproxy/stats file already exists.. skipping..."
    fi

    if [ ! -f "$haproxyconffile" ]
    then
        wget https://gist.githubusercontent.com/caroseuk/cc16fbef5e94a3a38837b50690eebb14/raw/79549fdd7a134e1d847d491d9867167c04fbf9a6/gistfile1.txt -O /etc/haproxy/haproxy.cfg &> /dev/null
        #cp ~/haproxy-$HAPVersion/examples/content-sw-sample.cfg /etc/haproxy/haproxy.cfg
    else
        echo "/etc/haproxy/haproxy.cfg file already exists.. skipping..."
    fi

## Create new user for HAProxy to run as
echo "* Adding haproxy user (if not already created)..."
useradd -r haproxy
echo ""

## Reload system daemon to recognize newly created HAproxy init.d file
echo "* Finishing up, reloading daemon-reload"
systemctl daemon-reload
echo ""

## Install complete, give user the good news.
echo "** HA Proxy $HAPVersion Installed and example configuration copied **"
