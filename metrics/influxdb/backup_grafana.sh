#!/bin/bash

SERVICE=$(basename "$(pwd)")
CNT=$(docker ps -f label=com.docker.swarm.service.name=${SERVICE}_frontend -q)

set -x
docker exec -t ${CNT} rm -f /opt/grafana/sql/dashboards/*
docker exec -t ${CNT} /opt/qnib/grafana/bin/backup_dash.sh /opt/grafana/sql/dashboards/
