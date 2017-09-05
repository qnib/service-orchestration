# Kafka Stack w/ metrics

Complete support stack to run a clustered kafka along with a metric gathering stack.
Different kafka versions can be started using the subdirectoryies.

## Start the Support Stack

```bash
$ docker stack deploy --compose-file docker-compose.yml kafka
Creating network kafka_default
Creating service kafka_zkui
Creating service kafka_kafka-manager
Creating service kafka_zookeeper
$ docker service ls -f label=com.docker.stack.namespace=kafka
docker service ls -f label=com.docker.stack.namespace=kafka
ID                  NAME                  MODE                REPLICAS            IMAGE                                                                                              PORTS
9sl5u78z1bfw        kafka_kafka-manager   replicated          1/1                 qnib/plain-kafka-manager@sha256:ef6d4e250264c436d647023e16fce22408d299086d9301668cd40b7eb1529228   *:9001->9000/tcp
hkdwhrep9ig6        kafka_zkui            replicated          1/1                 qnib/plain-zkui@sha256:d66972bd886ade9a8d7383f5064bd825f6d29275a282250cb0adf52475f67726            *:9090->9090/tcp
przy481bvwlg        kafka_zookeeper       replicated          1/1                 qnib/plain-zookeeper@sha256:593f8b807412837d52be111575a544b9fcb4db79868cab1c6819fbcc9c0568b7       *:2181->2181/tcp
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
ID                  NAME                    MODE                REPLICAS            IMAGE                                                                                                          PORTS
9sl5u78z1bfw        kafka_kafka-manager     replicated          1/1                 qnib/plain-kafka-manager@sha256:ef6d4e250264c436d647023e16fce22408d299086d9301668cd40b7eb1529228               *:9001->9000/tcp
gwxlaa07g9rh        kafka_influxdb          replicated          1/1                 qnib/plain-influxdb@sha256:fd65e66b559b3a9f367051212804bb1da9cf115b0fd93663bef4f522702bc5ab                    *:8083->8083/tcp,*:8086->8086/tcp
hkdwhrep9ig6        kafka_zkui              replicated          1/1                 qnib/plain-zkui@sha256:d66972bd886ade9a8d7383f5064bd825f6d29275a282250cb0adf52475f67726                        *:9090->9090/tcp
pooqd28abph4        kafka_prometheus        replicated          1/1                 qnib/plain-prometheus@sha256:9e5f625a6684c8e1f9995091923cc5144e84a66914392cd1ecbe518ba9f2f261                  *:9091->9090/tcp
przy481bvwlg        kafka_zookeeper         replicated          1/1                 qnib/plain-zookeeper@sha256:593f8b807412837d52be111575a544b9fcb4db79868cab1c6819fbcc9c0568b7                   *:2181->2181/tcp
q348aoozd5xf        kafka_storage-adapter   replicated          1/1                 qnib/plain-prometheus-remote-storage@sha256:4cb6929eb83c2f171b51877ea77765c9f6f31b081710ffa7e0c1230abf6b96e1
r0dqyr0ldowe        kafka_grafana           replicated          1/1                 qnib/plain-grafana4@sha256:c63b3a77369ab3490494f069069ca151201623cb71bebf6c6abbe38029bb3c9e                    *:3000->3000/tcp
$ 
```

## Start kafka broker

The subdirectories provide different versions of kafka, assuming that the network used by the support stack is called `kafka_default`.

```bash
$ docker stack deploy --compose-file alpine-0.10.2.1/docker-compose.yml kafka
Creating service kafka_broker
```
