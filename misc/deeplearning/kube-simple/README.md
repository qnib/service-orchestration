# Deep Learning Simulation

Kube deployment with a scalable simulation pod and a single trainer.

```
trainer - policy1 - simulation1
/       \
policy2      policy3 - simulation3
|
simulation2
```

## ReplicaSet

This deployment comprises of one Pod and one StatefulSet:

- **trainer** (Pod): Which holds the qnib/trainer image
- **simulation** (StatefulSet): which holds two containers; `policy` and `sim`

<details><summary>Trainer Pod</summary>
<p>
The most up-to-date file is `pod-trainer.yml`.
```
apiVersion: v1
kind: Pod
metadata:
  name: trainer
  labels:
    app: trainer
spec:
  imagePullSecrets:
  - name: my-secret
  containers:
  - name: trainer
    image: ec2-34-242-200-232.eu-west-1.compute.amazonaws.com/qnib/trainer:v5
    env:
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
```
</p>
</details>

<details><summary>Simulation StatefulSet</summary>
<p>
The most up-to-date file is `sset-simulation.yml`.
```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: policy
spec:
  selector:
    matchLabels:
      app: simulation # has to match .spec.template.metadata.labels
  serviceName: "simulation"
  replicas: 3 # by default is 1
  template:
    metadata:
      labels:
        app: simulation # has to match .spec.selector.matchLabels
    spec:
      containers:
      - name: policy
        image: ec2-34-242-200-232.eu-west-1.compute.amazonaws.com/qnib/policy:v4
        ports:
        - containerPort: 9991
          name: policy
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
      - name: sim
        image: ec2-34-242-200-232.eu-west-1.compute.amazonaws.com/qnib/sim:v4
        ports:
        - containerPort: 9992
          name: sim
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
```
</p>
</details>

## Services

TO make them accessible services are created.
<details><summary>Trainer Service</summary>
<p>
```
apiVersion: v1
kind: Service
metadata:
  name: trainer
spec:
  ports:
    - port: 9993
      targetPort: 9993
      name: trainer
  selector:
    app: trainer
```
</p>
</details>
<details><summary>Simulation Service</summary>
<p>
```
apiVersion: v1
kind: Service
metadata:
  name: simulation
spec:
  ports:
    - port: 9991
      targetPort: 9991
      name: policy
    - port: 9992
      targetPort: 9992
      name: sim
  selector:
    app: simulation
```
</p>
</details>

### Fire it up

```
➜  kube git:(master) ✗ kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   28d
➜  kube git:(master) ✗ kubectl apply -f .
pod "trainer" created
service "simulation" created
service "trainer" created
statefulset.apps "policy" created
```
In order to query the pods a jump-pod is created.

```
➜  kube git:(master) ✗ kubectl apply -f misc/jumpod.yml
pod "jumpod" created
```
### Curl the services
Once all is up-n-running...
```
➜  kube git:(master) ✗ kubectl get all
NAME           READY     STATUS    RESTARTS   AGE
pod/jumpod     1/1       Running   0          44m
pod/policy-0   2/2       Running   0          13s
pod/policy-1   2/2       Running   0          11s
pod/policy-2   2/2       Running   0          9s
pod/trainer    1/1       Running   0          13s

NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)             AGE
service/kubernetes   ClusterIP   10.96.0.1     <none>        443/TCP             28d
service/simulation   ClusterIP   None          <none>        9991/TCP,9992/TCP   13s
service/trainer      ClusterIP   10.108.75.4   <none>        9993/TCP            13s

NAME                      DESIRED   CURRENT   AGE
statefulset.apps/policy   3         3         13s
```
...the jumpod can curl the services.

```
➜  kube git:(master) ✗ kubectl exec jumpod -c shell -i -t -- curl simulation.default.svc.cluster.local:9991
You've hit cnt:policy at path:/ on pod:policy-1
IP: 10.1.0.112
Port: 54400
➜  kube git:(master) ✗ kubectl exec jumpod -c shell -i -t -- curl simulation.default.svc.cluster.local:9991
You've hit cnt:policy at path:/ on pod:policy-2
IP: 10.1.0.112
Port: 33058
➜  kube git:(master) ✗ kubectl exec jumpod -c shell -i -t -- curl trainer.default.svc.cluster.local:9993
You've hit cnt:trainer at path:/ on pod:trainer
IP: 10.1.0.112
Port: 44670
```

### Use stable DNS names
As StatefulSet will keep the DNS name... stable... we can address pods directly.

```
➜  kube git:(master) ✗ kubectl exec jumpod -c shell -i -t -- curl policy-1.simulation.default.svc.cluster.local:9991
You've hit cnt:policy at path:/ on pod:policy-1
IP: 10.1.0.112
Port: 59744
➜  kube git:(master) ✗ kubectl exec jumpod -c shell -i -t -- curl policy-0.simulation.default.svc.cluster.local:9991
You've hit cnt:policy at path:/ on pod:policy-0
IP: 10.1.0.112
Port: 41970
```
