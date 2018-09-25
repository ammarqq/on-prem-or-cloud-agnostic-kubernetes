# Rook
rook is opensource  orchestrator for distributed storage systems running in kubernetes
it allows u to use storage systems onkuberentes cluster

rook automates the configuration, deployment,maintenace  of distributed  storage software
in this way u don't need to worry about the difficults of setting up storage systems.

rook using ceph as undelying storage, but minio and cockroachDB are available also

Demo


Examples from https://github.com/rook/rook/tree/master/cluster/examples/kubernetes

Install rook:
```
kubectl create -f rook-operator.yaml
kubectl create -f rook-cluster.yaml
```

Storage:
```
kubectl create -f rook-storageclass.yaml
```

Rook tools:
```
kubectl create -f rook-tools.yaml
```
kubectl exec -it rook-tools  -n rook -- bash
rookctl status

MySQL demo:
```
kubectl create -f mysql-demo.yaml
```
kubectl exec -it demo-mysqlPODNAME -- bash

mysql -u root -p changeme
create database db;

make sure where is the pod on any node
kubectl cordon node3
kubectl delete pod mysqlFDSF#
kubectl get pod


# object storage
kubectl uncordon node02


Create object storage:
```
kubectl create -f rook-storageclass-objectstore.yaml

```

Create user:
kubectl exec -it rook-tools -n rook -- bash
```
radosgw-admin user create --uid rook-user --display-name "A rook rgw User" --rgw-realm=my-store --rgw-zonegroup=my-store
```

Export variables
```
export AWS_HOST=rook-ceph-rgw-my-store.rook <-- namespace
export AWS_ENDPOINT=clusterIP of ceoh-rgw(get it from svc)
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
```
we can use commands
s3cmd --help
s3cmd mb --no-ssl --host=${AWS_HOST} --host-bucket= s3://demobucket

echo 'hello world' > test
cat test
s3cmd put test --no-ssl --host=${AWS_HOST} --host-bucket= s3://demobucket

s3cmd ls --no-ssl --host=${AWS_HOST} --host-bucket= s3://demobucket