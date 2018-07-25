# Swarmprom plus ELK

## Prerequisites
### GPU

To schedule the gpu exporter the GPU-nodes need to carry the label `houdini.gpu=true`.

```bash
$ docker node update spksvt6g6puu2x11xy78t4txs --label-add houdini.gpu=true
spksvt6g6puu2x11xy78t4txs
$ docker node inspect -f '{{json .Spec.Labels}}' spksvt6g6puu2x11xy78t4txs |jq . |grep houdini
  "houdini.gpu": "true"
```

## Install

```bash
$ docker-app deploy swarmprom
$ docker-app deploy elk
```
