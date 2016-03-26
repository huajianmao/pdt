#!/bin/bash

VERSION=1.0.alpha.1
DST_DIR=/tmp/pdt/pack
CURRENT_DIR=`pwd`

RELEASE_DIR=$DST_DIR/release/$VERSION
BUILD_DIR=$DST_DIR/build
TMP_BIN_DIR=$DST_DIR/build/tmp
WINDOWS_EXE_DIR=$RELEASE_DIR/bin
mkdir -p $RELEASE_DIR
mkdir -p $BUILD_DIR
mkdir $RELEASE_DIR/{bin,doc,patch,src,scripts}

cp apt-cyg $RELEASE_DIR/apt-cyg

cp doc/使用说明文档.md $RELEASE_DIR/doc/使用说明文档.html
cp doc/使用说明文档.md $RELEASE_DIR/doc/使用说明文档.html
cp doc/编译安装文档.md $RELEASE_DIR/doc/编译安装文档.html
cp doc/性能测试报告.md $RELEASE_DIR/doc/性能测试报告.md
cp doc/编译安装文档.md $RELEASE_DIR/doc/编译安装文档.md
cp doc/性能测试报告.md $RELEASE_DIR/doc/性能测试报告.md
cp doc/wdt.vs.lftp.jpg $RELEASE_DIR/doc/wdt.vs.lftp.jpg

cp patch/wdt.patch $RELEASE_DIR/patch/wdt.patch
cp patch/glog.patch $RELEASE_DIR/patch/glog.patch

cp scripts/setup.sh $RELEASE_DIR/scripts/setup.sh

cd $RELEASE_DIR/src
git clone https://github.com/google/double-conversion
git clone https://github.com/gflags/gflags
git clone https://github.com/google/glog
git clone https://github.com/google/googletest
git clone https://github.com/facebook/folly
git clone https://github.com/facebook/wdt

cp -a $RELEASE_DIR $BUILD_DIR/
cd $BUILD_DIR/$VERSION

export INSTALL_PREFIX=$TMP_BIN_DIR
export OS_NAME=`uname -a | cut -d' ' -f 1 |  tr '[:upper:]' '[:lower:]'`
rm -r $INSTALL_PREFIX
mkdir -p $INSTALL_PREFIX/bin $INSTALL_PREFIX/lib
export PATH=$INSTALL_PREFIX/bin:$INSTALL_PREFIX/lib:$PATH

if [ -z "${OS_NAME##*cygwin*}" ]; then
  chmod +x apt-cyg; cp apt-cyg $INSTALL_PREFIX/bin/
  apt-cyg install -m http://mirrors.aliyun.com/cygwin \
    gcc-g++ cmake make automake1.14 autoconf-archive autoconf2.5 gdb openssh openssl-devel\
    pkg-config patch libboost-devel libtool
fi

mkdir -p build

(mkdir build/double-conversion; cd build/double-conversion; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/double-conversion; make -j 2; make install)

(mkdir build/gflags; cd build/gflags; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DGFLAGS_NAMESPACE=google ../../src/gflags; make -j 2; make install)

(cd src/glog; git apply ../../patch/glog.patch;)
(export CXXFLAGS="-fPIC" && mkdir build/glog; cd build/glog; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/glog; make; make -j 2; make install)

(mkdir build/googletest; cd build/googletest; cmake -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/googletest; make; make -j 2; make install)

(cd src/wdt; git apply ../../patch/wdt.patch;)
(mkdir build/wdt; cd build/wdt; cmake -DBUILD_TESTING=1 -DBUILD_SHARED_LIBS=on -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX ../../src/wdt;  make; make -j 2; make install;)

if [ -z "${OS_NAME##*cygwin*}" ]; then
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
fi

cd $DST_DIR/release/
tar zcf pdt-$VERSION.tar.gz $VERSION

cd $CURRENT_DIR
RELEASE_FILE=$DST_DIR/release/pdt-$VERSION.tar.gz
echo "The generated package is [$RELEASE_FILE]"
ls -l $RELEASE_FILE
