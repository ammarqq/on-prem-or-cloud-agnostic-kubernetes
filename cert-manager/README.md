# install nginx ingress

letsencrypt.org is a free,automated and open  Certificate authority.
it issue certificate for free.


first we need to install helm , go to repository helm 
install helm on ur machine laptop.

kubectl create -f rbac-config.yml
helm init --service-account tiller
now goto cert-manager directory.


```
helm install --name my-ingress stable/nginx-ingress \
  --set controller.kind=DaemonSet \
  --set controller.service.type=NodePort \
  --set controller.hostNetwork=true

  kubctl edit pods nginx
```
open http and https on the firewall
# start myapp

Create myapp and add an ingress rule:

```
kubectl create -f myapp.yml
kubectl create -f myapp-ingress.yml
```
kubectl get ingress
check the url

http://myapp.psamman.com
# install cert-manager

```
helm install \
    --name cert-manager \
    --namespace kube-system \
    stable/cert-manager
```
now we need to run 
kubectl create -f issuer-staging.yml
kubectl create -f issuer-prod.yml

nowin certificate-staging.yml

change the appname
kubectl create -f certificate-staging.yml
kubectl get certificates
kubect describe certificates myapp
kubectl describe ingress

now go to myapp-ingress.yml and enable the tls 

 tls:
  - secretName: myapp-tls-staging
    hosts:
  #  - myapp.newtech.academy
    -  myapp.psamman.com

    now run it 
    kubectl apply -f myapp-ingress.yml
    open https://myapp.psamman.com u will notice warning to resolve it u have to use production certificate


kubectl delete -f certificate-staging.yml

    kubectl create -f certificate-prod.yml
we need tochange myapp-ingress.yml 


tls:
  - secretName: myapp-tls-staging ---> secretName: myapp-tls-prod
    hosts:
  #  - myapp.newtech.academy
    -  myapp.psamman.com


now apply it
kubectl apply -f myapp-ingress.yml
