#!/bin/bash

[ -n "$INSTALL_PREFIX" ] || INSTALL_PREFIX=/tmp/pdt
(cd build/wdt; export PATH=$INSTALL_PREFIX/bin:$INSTALL_PREFIX/lib:$PATH; CTEST_OUTPUT_ON_FAILURE=1 make test;)
