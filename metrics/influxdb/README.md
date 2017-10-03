# InfluxDB Stack (v3 compliant)

This stack instanciates InfluxDB as a backend and Grafana4 as frontend.

**Disclaimer**: You need to install docker >1.13

## SpinUp

```
$ docker deploy -c docker-compose.yml influx
Creating network influx_default
Creating service influx_backend
Creating service influx_frontend
$ docker service ls
ID            NAME             MODE        REPLICAS  IMAGE
i73pbgofy5t6  influxdb_backend   replicated  1/1       qnib/plain-influxdb
oqszaqmumgy3  influxdb_frontend  replicated  1/1       qnib/plain-grafana4
```

#### Extract SQL for given dashboard (alert)

If you changed the dashboards, you can extract the SQL to funnel it back into the grafana4 image.

```
$  ./backup_grafana.sh dashboard docker-engine
INSERT INTO "dashboard" VALUES(5,5,'docker-engine','Docker Engine',X'7B2*snip*
6F6E223A357D',1,'2016-10-23 14:01:14','2016-11-20 15:54:25',1,NULL,NULL,NULL);
```
