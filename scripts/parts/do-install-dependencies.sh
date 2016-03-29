#!/bin/bash

OS_NAME=`uname -a | cut -d' ' -f 1 |  tr '[:upper:]' '[:lower:]'`
if [ -z "${OS_NAME##*cygwin*}" ]; then
  chmod +x apt-cyg
  sh apt-cyg install -m http://mirrors.aliyun.com/cygwin \
    gcc-g++ cmake make automake1.14 autoconf-archive autoconf2.5 gdb openssh openssl-devel\
    pkg-config patch libboost-devel libtool
else
  echo "FIXME: to install the packages!"
fi
