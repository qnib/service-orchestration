# service-orchestration
Repo to collect container service stacks.

**I am currently reorganising this repository, make sure to check back :)**
## M.E.L.I.T.A. Stacks

The directories starting with a capital letter are holding the different sub-stacks:

### **M**etrics

 - *Grafana* stack, providing an InfluxDB backend, the UI Chronograph (including the admin UI) and powerful Grafana4 frontend to visualise metrics.

### **E**vents_**L**ogs
 - *Kibana* stack, including Elasticsearch as a backend and Kibana as a powerful frontend.

### **I**nventory
 - (*to-be-added*) *Neo4j* as an easy to use graph database.

### **T**racing
  - (*to-be-added*) *Zippkin* commonly used tracing backend and UI

### **A**nalytics
  - **Alerting**
    - (*to-be-added*) *Bosun* Framework which can plug into InfluxDB or Graphite.
    - (*to-be-added*) *Prometheus* Collection, scratch-backend and alerting tool
  - **Stream Processing**
    - (*to-be-added*) *KSQL* SQL Stream processing with Kafka Streams

## Use-Cases

Combinations of stacks to match a use-case. E.g. overlapping the Events/Logs and the Metrics stacks benefits both, as they are tightly related. Looking at metrics charts overlayed by logs/events makes an awful lot of sense.

## Misc

Stacks which do not fit in the other directories are put into `misc`. :)

### Collection

The directory `collection` holds stacks to collect and/or aggregate data, which can be processed using the stacks within this repository.

### Backends

Pure backend stacks can be found in `backends`.

- *Elasticsearch* text (Log/Event data)* indexing database, as a single container or as a distributed setup.
- *InfluxDB* Metrics backend (recently added Tracing capability) written in GO (thus easy to operate).

### CI/CD

- **GoCD** A Continuous Delivery/Integration pipeline created by Thought-works with a nice (IMHO the nicest) UI.