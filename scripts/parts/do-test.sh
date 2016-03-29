#!/bin/bash

[ -n "$DO_TEST" ] || DO_TEST=off
[ -n "$INSTALL_PREFIX" ] || INSTALL_PREFIX=/tmp/pdt

if [ "$DO_TEST" = "on" ]; then
  (cd build/wdt; export PATH=$INSTALL_PREFIX/bin:$INSTALL_PREFIX/lib:$PATH; CTEST_OUTPUT_ON_FAILURE=1 make test;)
fi
