#!/bin/sh
set -e

if [ -d /opt/app ] && [ ! -e /opt/app/node_modules ]; then
  ln -s /opt/node_modules /opt/app/node_modules
fi

exec "$@"
