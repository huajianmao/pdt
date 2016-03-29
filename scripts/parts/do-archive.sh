#!/bin/bash

[ -n "$INSTALL_PREFIX" ] || INSTALL_PREFIX=/tmp/pdt
[ -n "$WINDOWS_EXE_DIR" ] || WINDOWS_EXE_DIR=$INSTALL_PREFIX/exe

OS_NAME=`uname -a | cut -d' ' -f 1 |  tr '[:upper:]' '[:lower:]'`

if [ -z "${OS_NAME##*cygwin*}" ]; then
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
fi
