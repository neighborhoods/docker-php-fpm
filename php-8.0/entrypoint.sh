#! /bin/bash

set -e

echo "Starting entrypoint script"
CONF_DIR="/usr/local/etc/php/conf.d"

echo "Done with entrypoint, running 'exec $@'"
exec "$@"
