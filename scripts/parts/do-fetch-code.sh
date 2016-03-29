#!/bin/bash
[ -n "$IS_GIT_REPO" ] || IS_GIT_REPO=True
[ -n "$DST_SRC_DIR" ] || DST_SRC_DIR=src

if [ "$IS_GIT_REPO" = "True" ]; then
  git submodule init
  git submodule update
else
  (cd src; git clone https://github.com/google/double-conversion)
  (cd src; git clone https://github.com/gflags/gflags)
  (cd src; git clone https://github.com/google/glog)
  (cd src; git clone https://github.com/google/googletest)
  (cd src; git clone https://github.com/facebook/folly)
  (cd src; git clone https://github.com/facebook/wdt)
fi
