# KSQL
Stack to push docker events into kafka and use the KSQL stream processor to join the different events.

### Producer

To feed the KSQL processor a producer is used. Just create a new bash in the broker and drop `JMX_PORT`.

```
$ docker exec -ti $(docker ps -qf label=com.docker.swarm.service.name=ksql_broker) bash
$ unset JMX_PORT
$ /opt/kafka/bin/kafka-console-producer.sh --broker-list tasks.broker:9092 --topic input
{"data":"test"}
{"data":"test3"}
```

### KSQL

```
$ docker exec -ti $(docker ps -qf label=com.docker.swarm.service.name=ksql_engine) bash
bash-4.3# cd /opt/ksql/bin
bash-4.3# ./ksql-cli remote http://localhost:9098
ksql> CREATE STREAM data (data VARCHAR) WITH (VALUE_FORMAT = 'JSON', KAFKA_TOPIC = 'input');

 Message
----------------
 Stream created
ksql> SHOW STREAMS;

 Stream Name | Kafka Topic | Format
------------------------------------
 DATA        | input       | JSON
ksql> SELECT * FROM data;
1507107288461 | null | test3
```
