#!/bin/bash

if [ $# -ne 2 ];then
   echo ">> ./backup.sh dashboard|alert <name>"
   exit 1
fi
NODE=$(docker service ps -f desired-state=running influx_frontend | awk '/_frontend/{print $4}')
ADDR=$(docker node inspect -f '{{ .Status.Addr }}' ${NODE})
if [ "${NODE}" == "moby" ];then
    DOCKER_HOST=unix:///var/run/docker.sock
else
    DOCKER_HOST=${ADDR}:2376
fi
CNT_NAME=$(docker ps | awk '/_frontend/{print $NF}')
docker exec -t ${CNT_NAME} sqlite3 /var/lib/grafana/grafana.db .dump | egrep "INSERT INTO \"${1}\".*${2}"

