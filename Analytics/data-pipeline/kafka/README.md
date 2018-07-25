# Kafka Stack w/ metrics

Complete support stack to run a clustered kafka along with a metric gathering stack.
Different kafka versions can be started using the subdirectoryies.

## Start the Support Stack



```bash
$ docker-app deploy
Creating network kafka_default
Creating service kafka_zookeeper
Creating service kafka_zkui
Creating service kafka_broker
Creating service kafka_manager
$ sleep 60 ; docker service ls -f label=com.docker.stack.namespace=kafka
ID                  NAME                  MODE                REPLICAS            IMAGE                               PORTS
z1wozetio2zn        kafka_broker        replicated          3/3                 qnib/plain-kafka:1.1.1
1eiti1961vfc        kafka_manager       replicated          1/1                 qnib/plain-kafka-manager:1.3.3.18   *:9000->9000/tcp
khcykv3zqyj5        kafka_zkui          replicated          1/1                 qnib/plain-zkui:8d3441d             *:9090->9090/tcp
tfiq5uvmot4f        kafka_zookeeper     replicated          1/1                 qnib/plain-zookeeper:2018-04-25
$
```


## Start the metrics stack

```bash
$ docker stack deploy --compose-file metrics.yml kafka
Creating service kafka_prometheus
Creating service kafka_storage-adapter
Creating service kafka_influxdb
Creating service kafka_grafana
$ docker service ls -f label=com.docker.stack.namespace=kafka
ID                  NAME                    MODE                REPLICAS            IMAGE                                          PORTS
2ysqrm0q5z0g        kafka_zkui              replicated          1/1                 qnib/plain-zkui:8d3441d                        *:9090->9090/tcp
dr9i1m1bcqns        kafka_influxdb          replicated          1/1                 qnib/plain-influxdb:1.3.5                      *:8083->8083/tcp,*:8086->8086/tcp
e2qap6oqstsv        kafka_storage-adapter   replicated          1/1                 qnib/plain-prometheus-remote-storage:aa5cdcb
f1p8yoo4slvt        kafka_zookeeper         replicated          1/1                 qnib/plain-zookeeper:3.4.10                    *:2181->2181/tcp
mda7aqyhxg6j        kafka_grafana           replicated          1/1                 qnib/plain-grafana4:4.4.3-1                    *:3000->3000/tcp
qo8hg3hhv5zp        kafka_kafka-manager     replicated          1/1                 qnib/plain-kafka-manager:1.3.3.13              *:9001->9000/tcp
rcnlws7seo4m        kafka_prometheus        replicated          1/1                 qnib/plain-prometheus:1.7.1-4                  *:9091->9090/tcp
$
```
