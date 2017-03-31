#!/bin/bash

DATA_DIR=${DATA_DIR:-/var/lib/influxdb/}
SERVICE=$(basename "$(pwd)")

/opt/service-scripts/gocd/common/bin/download-artifacts.sh
IMG_NAME=$(find ./target/ -name "*.image_name" |head -n1)

## Which current images are used?
docker service ls |grep "${SERVICE}_" |awk '{print $2" "$5}' | while read l
do
  SVC_NAME=$(echo $l |awk '{print $1}' |cut -d'_' -f 2-)
  IMG_FULL=$(echo $l |awk '{print $2}')
  IMG_NAME=$(echo ${IMG_FULL} |awk -F/ '{print $NF}' |awk -F'\:|@' '{print $1}')
  echo "[DEBUG] ${SVC_NAME} uses currently ${IMG_FULL}"
  if [[ -f ./target/${IMG_NAME}.image_name ]];then
      IMG_FULL=$(cat ./target/${IMG_NAME}.image_name)
      echo "[DEBUG] Found updated image by parent, now ${IMG_FULL}"
  fi
  declare "${SVC_NAME}_IMG=${IMG_FULL}"
  export ${SVC_NAME}_IMG
done


echo "[II] Ensure data dir '${DATA_DIR}/{grafana/sql,influxdb}' is present"
# Idempotent, as it uses 'mkdir -p'. Even though it mounts the root of the server it can 'only' create arbitrary directories.
export DATA_DIR
docker run -t --rm -v /:/root_dir/ alpine mkdir -p /root_dir/${DATA_DIR}/{grafana/sql,influxdb}
echo "[II] Deploy stack from docker-compose file"
docker stack deploy --compose-file docker-compose.yml ${SERVICE}
