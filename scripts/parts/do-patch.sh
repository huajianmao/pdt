#!/bin/bash

[ -n "$DO_PATCH" ] || DO_PATCH=on
[ -n "$INSTALL_PREFIX" ] || INSTALL_PREFIX=/tmp/pdt

if [ "$DO_PATCH" = "on" ]; then
  (cd src/glog; git apply ../../patch/glog.patch;)
  (cd src/wdt; git apply ../../patch/wdt.patch;)
fi
