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

Assuming each of the tasks should use one GPU exclusively, this can only be achieved by pining the NVIDIA_VISIBLE_DEVICES carefully.
A better approach, would ask the Engine to provide a certain amount of GPUs. If the engine is out of GPUs it should just drop the task, which would reschedule.

- [ ] `HOUDINI_GPU_REQUEST` will request an amount of GPUs from the engine, which will be used exclusivly.

## Engine vs. Orchestrator
Of course the engine is not the ideal place for this decision. The Orchestrator should just know about the amount of GPUs and act accordingly.
Just as an experiment, in case one does not have the liberty of changing the orchestrator.

Kubernetes provides a devices plugin which might just works fine in case the runtime supports `NVIDIA_VISIBLE_DEVICES` support.
