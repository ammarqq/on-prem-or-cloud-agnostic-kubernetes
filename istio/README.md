# istio install

download (0.7.1):
```
on master-node download the file

wget https://github.com/istio/istio/releases/download/0.7.1/istio-0.7.1-linux.tar.gz
tar -xzvf istio-0.7.1-linux.tar.gz
cd istio-0.7.1
echo 'export PATH="$PATH:/home/ubuntu/istio-0.7.1/bin"' >> ~/.profile
```

Download (latest):
```
curl -L https://git.io/getLatestIstio | sh -
echo 'export PATH="$PATH:/home/ubuntu/istio-0.7.1/bin"' >> ~/.profile # change 0.7.1 in your version
cd istio-0.7.1 # change 0.7.1 in your version
```

with no mutual TLS authentication
```
kubectl apply -f install/kubernetes/istio.yaml -->use this one .. execute it twice.
```

or with mutual TLS authentication
```
kubectl apply -f install/kubernetes/istio-auth.yaml
```

Example app (from istio)
aswedont have loadbalancer 
```
kubectl edit svc istio-ingress -n istio-system # change loadbalancer to nodeport (or use hostport)

kubectl get svc -n istio-system

export PATH="$PATH:/home/ubuntu/istio-0.7.1/bin"
kubectl apply -f <(istioctl kube-inject --debug -f samples/bookinfo/kube/bookinfo.yaml)
```
kubectl get pods

kubectl edit productpage-v1-787df8db4-6429d

http://104.248.239.115:32383/productpage   master-node ip

# Traffic management

Add default route to v1:
```
istioctl create -f samples/bookinfo/routing/route-rule-all-v1.yaml
```

Route traffic to v2 if rule matches
```
istioctl replace -f samples/bookinfo/routing/route-rule-reviews-test-v2.yaml
```

Route 50% of traffic between v1 and v3:
```
istioctl replace -f samples/bookinfo/routing/route-rule-reviews-50-v3.yaml
```

# Distributed tracing

Enable zipkin:
```
kubectl apply -f install/kubernetes/addons/zipkin.yaml
```

Enable Jaeger:
```
kubectl delete -f install/kubernetes/addons/zipkin.yaml # if zipkin was installed, delete it first
kubectl apply -n istio-system -f https://raw.githubusercontent.com/jaegertracing/jaeger-kubernetes/master/all-in-one/jaeger-all-in-one-template.yml

```

