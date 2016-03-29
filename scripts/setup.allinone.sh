#!/bin/bash

[ -n "$ENABLE_DEBUG" ] || ENABLE_DEBUG=off
[ -n "$INSTALL_PREFIX" ] || INSTALL_PREFIX=/tmp/pdt

rm -r $INSTALL_PREFIX
mkdir -p $INSTALL_PREFIX/bin $INSTALL_PREFIX/lib
PATH=$INSTALL_PREFIX/bin:$INSTALL_PREFIX/lib:$PATH

[ -n "$FETCH_FROM_GITHUB" ] || FETCH_FROM_GITHUB=on
if [ "$FETCH_FROM_GITHUB" = "on" ]; then
  sh scripts/parts/do-fetch-code.sh;
fi

[ -n "$DO_INSTALL_DEP" ] || DO_INSTALL_DEP=on
if [ "$DO_INSTALL_DEP" = "on" ]; then
  sh scripts/parts/do-install-dependencies.sh
fi

[ -n "$DO_PATCH" ] || DO_PATCH=on
if [ "$DO_PATCH" = "on" ]; then
  sh scripts/parts/do-patch.sh
fi

sh scripts/parts/do-build.sh

[ -n "$DO_TEST" ] || DO_TEST=off
if [ "$DO_TEST" = "on" ]; then
  sh scripts/parts/do-test.sh
fi

[ -n "$DO_ARCHIVE" ] || DO_ARCHIVE=on
[ -n "$WINDOWS_EXE_DIR" ] || WINDOWS_EXE_DIR=$INSTALL_PREFIX/exe
if [ "$DO_ARCHIVE" = "on" ]; then
  sh scripts/parts/do-archive.sh
fi
