#!/bin/bash

[ -n "$VERSION" ] || VERSION=1.0.alpha.1
[ -n "$DST_DIR" ] || DST_DIR=/tmp/pdt/pack

RELEASE_DIR=$DST_DIR/release/$VERSION
CURRENT_DIR=`pwd`

mkdir -p $RELEASE_DIR
mkdir $RELEASE_DIR/{bin,doc,patch,src,scripts}

cp .gitignore $RELEASE_DIR/.gitignore
cp apt-cyg $RELEASE_DIR/apt-cyg
cp doc/使用说明文档.html $RELEASE_DIR/doc/使用说明文档.html
cp doc/编译安装文档.html $RELEASE_DIR/doc/编译安装文档.html
cp doc/性能测试报告.html $RELEASE_DIR/doc/性能测试报告.html
cp doc/使用说明文档.md $RELEASE_DIR/doc/使用说明文档.md
cp doc/编译安装文档.md $RELEASE_DIR/doc/编译安装文档.md
cp doc/性能测试报告.md $RELEASE_DIR/doc/性能测试报告.md
cp doc/pdt.vs.lftp.jpg $RELEASE_DIR/doc/pdt.vs.lftp.jpg
cp -a scripts/parts $RELEASE_DIR/scripts/
cp patch/wdt.patch $RELEASE_DIR/patch/wdt.patch
cp patch/glog.patch $RELEASE_DIR/patch/glog.patch

cd $RELEASE_DIR

BUILD_DIR=$DST_DIR/build
TMP_BIN_DIR=$DST_DIR/build/tmp
mkdir -p $BUILD_DIR
mkdir -p $TMP_BIN_DIR

IS_GIT_REPO=False sh scripts/parts/do-fetch-code.sh;
sh scripts/parts/do-patch.sh
rm -r $RELEASE_DIR/patch
rm -rf $RELEASE_DIR/src/double-conversion/.git
rm -rf $RELEASE_DIR/src/gflags/.git
rm -rf $RELEASE_DIR/src/glog/.git
rm -rf $RELEASE_DIR/src/googletest/.git
rm -rf $RELEASE_DIR/src/folly/.git
rm -rf $RELEASE_DIR/src/wdt/.git

sh scripts/parts/do-rename-wdt-to-pdt.sh

cp -a $RELEASE_DIR $BUILD_DIR/
cd $BUILD_DIR/$VERSION
PDT_NAME=pdt INSTALL_PREFIX=$TMP_BIN_DIR sh scripts/parts/do-build.sh
PDT_NAME=pdt WINDOWS_EXE_DIR=$RELEASE_DIR/bin INSTALL_PREFIX=$TMP_BIN_DIR sh scripts/parts/do-archive.sh

cd $RELEASE_DIR
cp scripts/parts/do-build.sh scripts/build.sh
cp scripts/parts/do-archive.sh scripts/archive.sh
rm -r scripts/parts

cd $DST_DIR/release/
tar zcf pdt-$VERSION.tar.gz $VERSION

cd $CURRENT_DIR
RELEASE_FILE=$DST_DIR/release/pdt-$VERSION.tar.gz
echo "The generated package is [$RELEASE_FILE]"
ls -l $RELEASE_FILE
