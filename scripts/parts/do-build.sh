#!/bin/bash

[ -n "$INSTALL_PREFIX" ] || INSTALL_PREFIX=/tmp/pdt
[ -n "$ENABLE_DEBUG" ] || ENABLE_DEBUG=off
[ -n "$WDT_NAME" ] || WDT_NAME=wdt

mkdir -p build

(mkdir build/double-conversion; cd build/double-conversion; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/double-conversion; make -j 2; make install)

(mkdir build/gflags; cd build/gflags; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DGFLAGS_NAMESPACE=google ../../src/gflags; make -j 2; make install)

(export CXXFLAGS="-fPIC" && mkdir build/glog; cd build/glog; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/glog; make; make -j 2; make install)

(mkdir build/googletest; cd build/googletest; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/googletest; make; make -j 2; make install)

if [ "$ENABLE_DEBUG" = "on" ]; then
  (cd src/${WDT_NAME}; sed -i "s/^set(CMAKE_BUILD_TYPE\sRelease)$/set(CMAKE_BUILD_TYPE Debug)/g" CMakeLists.txt)
fi
(mkdir build/${WDT_NAME}; cd build/${WDT_NAME}; cmake -DBUILD_TESTING=1 -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/${WDT_NAME};  make; make -j 2; make install;)

