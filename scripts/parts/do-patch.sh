#!/bin/bash

(cd src/glog; git apply ../../patch/glog.patch;)
(cd src/wdt; git apply ../../patch/wdt.patch;)
