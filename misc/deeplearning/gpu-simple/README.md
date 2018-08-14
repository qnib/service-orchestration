# Deep Learning Simulation

Same deployment as `kube-simple` (have a look there).

```
trainer - policy1 - simulation1
/       \
policy2      policy3 - simulation3
|
simulation2
```

In addition it uses a different image, which also exposes `/gpus`. :)
This mimics an image using CUDA to access underlaying devices.

## Underlaying Engine

This is a test-setup to explore an experimental Docker Engine: [Houdini](https://github.com/qnib/moby/blob/houdini/HOUDINI_INSTALL.md)

## Goal

The goal is to attach GPUs according to ENV Variables, so that a DL framework can be scheduled as a service.

- `HOUDINI_GPU_ENABLED` grants access to GPUs a host can offer, controlled by `NVIDIA_VISIBLE_DEVICES`
- `NVIDIA_VISIBLE_DEVICES` provides either `all` (all devices) or a list of indices (`0,2` tries to map `/dev/nvidia0` and `/dev/nvidia2`).

The problem is that in case multiple stacks are deployed, each container tasks needs to know where it is scheduled.

Assuming each of the tasks should use one GPU exclusively, this can only be achieved by pining the NVIDIA_VISIBLE_DEVICES carefully.
A better approach, would ask the Engine to provide a certain amount of GPUs. If the engine is out of GPUs it should just drop the task, which would reschedule.

- `HOUDINI_GPU_REQUEST` will request an amount of GPUs from the engine, which will be used exclusivly.

Given two workers:
*g3.8xlarge*
```
$ nvidia-smi -L
GPU 0: Tesla M60 (UUID: GPU-b85326fc-f486-6b57-87c3-86f035201a5d)
GPU 1: Tesla M60 (UUID: GPU-53f8f4ce-1c4e-035a-98a8-ca7a769d5489)
```
*g2.2xlarge*
```
$ nvidia-smi -L
GPU 0: GRID K520 (UUID: GPU-7802b7ad-aabe-2cf5-a871-90d966b79122)
```




### TL;DR HOUDINI_GPU_REQUESTED

Using `HOUDINI_GPU_REQUESTED` allows for multi-workload use of multi-GPU setups without coordination of who is using which GPU at a given point in time.

The above stack is deployed in two distinct kubernetes namespaces (`gpu1` and `gpu2`), which allows to developers to use the same stack without interfering each other. Each trainer requesting one GPU.

```
Found reservation for 'k8s_trainer_trainer_gpu1_b9756c65-9efa-11e8-af47-0242ac110010_0'"
Found reservation for 'k8s_trainer_trainer_gpu2_31fde940-9efc-11e8-af47-0242ac110010_0'"
```

By querying the simulation callback to reach out to the trainer, the distinct IDs of the GPUs are shown.

```
$ kubectl exec jumpod -c shell -i -t -- curl -X POST -H "Content-Type: application/json" \
                     -d '{"port":"9993", "path":"/gpus","host":"trainer.gpu2.svc.cluster.local"}' \
                     simulator.gpu2.svc.cluster.local:9991/callmeback
>>> Callback http://trainer.gpu2.svc.cluster.local:9993/gpus
trainer: HOUDINI_GPU_REQUESTED=1
GPU 0: Tesla M60 (UUID: GPU-53f8f4ce-1c4e-035a-98a8-ca7a769d5489)
$ kubectl exec -n gpu1 jumpod -c shell -i -t -- curl -X POST -H "Content-Type: application/json" \
                     -d '{"port":"9993", "path":"/gpus","host":"trainer.gpu1.svc.cluster.local"}' \
                     simulator.gpu1.svc.cluster.local:9991/callmeback
>>> Callback http://trainer.gpu1.svc.cluster.local:9993/gpus
trainer: HOUDINI_GPU_REQUESTED=1
GPU 0: Tesla M60 (UUID: GPU-b85326fc-f486-6b57-87c3-86f035201a5d)
```

## Engine vs. Orchestrator
Of course the engine is not the ideal place for this decision. The Orchestrator should just know about the amount of GPUs and act accordingly.
Just as an experiment, in case one does not have the liberty of changing the orchestrator.

Kubernetes provides a devices plugin which might just works fine in case the runtime supports `NVIDIA_VISIBLE_DEVICES` support.

## Deployement
To select nodes with houdini installed, the nodes are labeled.
```
$ kubectl label nodes <gpu_node> houdini.gpu=true
```

Afterwards the trainer, jump-pod and services are created.
```
$ kubectl apply -f .
pod "trainer" created
service "simulator" created
service "trainer" created
$ kubectl apply -f misc/jumpod.yml
pod "jumpod" created
```

### Kubernetes 1.8
Currently DockerEE2.0 comes with kubernetes 1.8.x - thus, without StatefulSet.

```
$ kubectl apply -f 1.8/rc-simulator.yml
replicationcontroller "simulator" created
```

### Kubernetes >=1.10
With stable hostnames, StatefulSet are much more fun.

```
$ kubectl apply -f 1.10/sset-simulator.yml
```

## Query gpus

```
$ kubectl exec jumpod -c shell -i -t -- curl simulator.default.svc.cluster.local:9991/gpus
policy: NVIDIA_VISIBLE_DEVICES=all,HOUDINI_GPU_ENABLED=true
GPU 0: Tesla M60 (UUID: GPU-b85326fc-f486-6b57-87c3-86f035201a5d)
GPU 1: Tesla M60 (UUID: GPU-53f8f4ce-1c4e-035a-98a8-ca7a769d5489)
$ kubectl exec jumpod -c shell -i -t -- curl simulator.default.svc.cluster.local:9992/gpus
sim: NVIDIA_VISIBLE_DEVICES=all,HOUDINI_GPU_ENABLED=true
GPU 0: Tesla M60 (UUID: GPU-b85326fc-f486-6b57-87c3-86f035201a5d)
GPU 1: Tesla M60 (UUID: GPU-53f8f4ce-1c4e-035a-98a8-ca7a769d5489)
```
