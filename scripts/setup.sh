#!/bin/bash

# 0. Set environment
export ENABLE_DEBUG=off
export DO_TEST=off
export FETCH_FROM_GITHUB=off

export INSTALL_PREFIX=/tmp/pdt

export OS_NAME=`uname -a | cut -d' ' -f 1 |  tr '[:upper:]' '[:lower:]'`

rm -r $INSTALL_PREFIX
# mkdir -p $INSTALL_PREFIX/{bin,lib} seems not work in sh.
mkdir -p $INSTALL_PREFIX/bin $INSTALL_PREFIX/lib
export PATH=$INSTALL_PREFIX/bin:$INSTALL_PREFIX/lib:$PATH


# 1. Get all dependant code from github
# git clone --recursive git@github.com:weinvent/pdt.git
if [ "$FETCH_FROM_GITHUB" = "on" ]; then
  git submodule init
  git submodule update
fi


# 2. Install libraries
if [ -z "${OS_NAME##*cygwin*}" ]; then
  chmod +x apt-cyg; cp apt-cyg $INSTALL_PREFIX/bin/
  apt-cyg install -m http://mirrors.aliyun.com/cygwin \
    gcc-g++ cmake make automake1.14 autoconf-archive autoconf2.5 gdb openssh openssl-devel\
    pkg-config patch libboost-devel libtool
else
  echo "FIXME: to install the packages!"
fi

mkdir -p build

# 3. Compile double-conversion
(mkdir build/double-conversion; cd build/double-conversion; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/double-conversion; make -j 2; make install)


# 4. Compile gflags
(mkdir build/gflags; cd build/gflags; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DGFLAGS_NAMESPACE=google ../../src/gflags; make -j 2; make install)


# 5. Compile glog
(cd src/glog; git apply ../../patch/glog.patch;)
(export CXXFLAGS="-fPIC" && mkdir build/glog; cd build/glog; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/glog; make; make -j 2; make install)


# 6. Compile google test
(mkdir build/googletest; cd build/googletest; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/googletest; make; make -j 2; make install)

# 7. Compile wdt
(cd src/wdt; git apply ../../patch/wdt.patch;)
if [ "$ENABLE_DEBUG" = "on" ]; then
  (cd src/wdt; sed -i "s/^set(CMAKE_BUILD_TYPE\sRelease)$/set(CMAKE_BUILD_TYPE Debug)/g" CMakeLists.txt)
fi
(mkdir build/wdt; cd build/wdt; cmake -DBUILD_TESTING=1 -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/wdt;  make; make -j 2; make install;)

# test if all the test cases pass
if [ "$DO_TEST" = "on" ]; then
  (cd build/wdt; export PATH=$INSTALL_PREFIX/bin:$INSTALL_PREFIX/lib:$PATH; CTEST_OUTPUT_ON_FAILURE=1 make test;)
fi

# 8. Copy all the dependant libraries to some directory
if [ -z "${OS_NAME##*cygwin*}" ]; then
  export WINDOWS_EXE_DIR=$INSTALL_PREFIX/exe

  rm -r $WINDOWS_EXE_DIR
  mkdir -p $WINDOWS_EXE_DIR

  cp /bin/cygwin1.dll $WINDOWS_EXE_DIR/

  cp /bin/cyggcc_s-seh-1.dll $WINDOWS_EXE_DIR/
  cp /bin/cygboost_system-1_58.dll $WINDOWS_EXE_DIR/
  cp /bin/cygstdc++-6.dll $WINDOWS_EXE_DIR/
  cp /bin/cyggcc_s-seh-1.dll $WINDOWS_EXE_DIR/
  cp /bin/cygcrypto-1.0.0.dll $WINDOWS_EXE_DIR/
  cp /bin/cygz.dll $WINDOWS_EXE_DIR/

  cp $INSTALL_PREFIX/lib/cyggflags-*.dll $WINDOWS_EXE_DIR/
  cp $INSTALL_PREFIX/bin/cygglog-*.dll $WINDOWS_EXE_DIR/
  cp $INSTALL_PREFIX/bin/cygwdt_min.dll $WINDOWS_EXE_DIR/
  cp $INSTALL_PREFIX/bin/cygfolly4wdt.dll $WINDOWS_EXE_DIR/
  cp $INSTALL_PREFIX/bin/wdt.exe $WINDOWS_EXE_DIR/
  # or cp $INSTALL_PREFIX/bin* $WINDOWS_EXE_DIR/
fi
