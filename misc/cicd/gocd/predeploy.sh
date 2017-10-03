#!/bin/bash

docker run -t --rm -v /var/lib/:/data/ alpine mkdir -p /data/gocd/serverBackups
