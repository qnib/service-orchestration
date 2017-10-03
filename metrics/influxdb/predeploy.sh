#!/bin/bash

DATA_DIR=${DATA_DIR:-/var/lib/}

echo "[II] Ensure data dir '${DATA_DIR}/{grafana/sql,influxdb}' is present"
# Idempotent, as it uses 'mkdir -p'. Even though it mounts the root of the server it can 'only' create arbitrary directories.
export DATA_DIR
docker run -t --rm -v /:/root_dir/ alpine mkdir -p /root_dir/${DATA_DIR}/{grafana/sql,influxdb}

