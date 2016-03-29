#!/bin/bash

[ -n "$DO_FETCH_CODE" ] || DO_FETCH_CODE=on

if [ "$DO_FETCH_CODE" = "on" ]; then
  git submodule init
  git submodule update
fi
