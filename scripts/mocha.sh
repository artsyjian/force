# !/usr/bin/bash

set -e -x

trap "exit" INT

mocha \
  --require source-map-support/register \
  --require should \
  --require lib/jade_hook.js \
  --require jsdom-global/register \
  --compilers js:babel-core/register,coffee:coffee-script/register \
  --timeout 30000 \
   $@
