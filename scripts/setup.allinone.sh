#!/bin/bash

[ -n "$ENABLE_DEBUG" ] || ENABLE_DEBUG=off
[ -n "$DO_TEST" ] || DO_TEST=off
[ -n "$FETCH_FROM_GITHUB" ] || FETCH_FROM_GITHUB=on
[ -n "$INSTALL_PREFIX" ] || INSTALL_PREFIX=/tmp/pdt
[ -n "$WINDOWS_EXE_DIR" ] || WINDOWS_EXE_DIR=$INSTALL_PREFIX/exe

rm -r $INSTALL_PREFIX
mkdir -p $INSTALL_PREFIX/bin $INSTALL_PREFIX/lib
PATH=$INSTALL_PREFIX/bin:$INSTALL_PREFIX/lib:$PATH

sh scripts/parts/do-fetch-code.sh
sh scripts/parts/do-install-dependencies.sh
sh scripts/parts/do-patch.sh
sh scripts/parts/do-build.sh
sh scripts/parts/do-archive.sh

