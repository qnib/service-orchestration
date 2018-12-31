#!/bin/bash

NAME_SUFFIX=$(date +"%F_%H-%M")
if [[ "X$2" != "X" ]];then
  NAME_SUFFIX="${2}-${NAME_SUFFIX}"
fi
BCKP_DIR=`docker exec -ti $1 ls -l --color=never /opt/go-server/artifacts/serverBackups |tail -n1 |awk '{print $NF}'`
echo "DIR: ${BCKP_DIR}"
SRC=$(echo ${1}:/opt/go-server/artifacts/serverBackups/${BCKP_DIR} |tr -d '[:cntrl:]')
mkdir -p temp
rm -rf ./temp/*
echo ">> Copy '${SRC}' from '$1'"
docker cp "${SRC}" ./temp/

unzip -d ./temp/ ./temp/$(echo ${BCKP_DIR}|tr -d '[:cntrl:]')/config-dir.zip
rm -rf ./temp/password.properties ./temp/$(echo ${BCKP_DIR}|tr -d '[:cntrl:]')
tar cf config/gocd-config-${NAME_SUFFIX}.tar -C temp .
rm -rf ./temp
