# Install dex
DEX with github


Create certificate:
```u need to change the dns name on the file gencert.sh
[alt_names]
DNS.1 = dex.newtech.academy
dex.newtech.academy its the first node
I will add dex.psamman.com to the first node ip 104.248.113.172

./gencert.sh
kubectl create -f dex-ns.yaml
#kubectl create secret tls dex.newtech.academy.tls -n dex --cert=ssl/cert.pem --key=ssl/key.pem
kubectl create secret tls dex.psamman.com.tls -n dex --cert=ssl/cert.pem --key=ssl/key.pem
sudo cp ssl/ca.pem /etc/kubernetes/pki/openid-ca.pem
```

Create secret:
```
on github we need to create organization wich is free
goto organization settings 

then go to oauth app
register an app
name: kubernetes dex
Homepage URL:http://dex.psamman.com
Authorization callback URL:https://dex.psamman.com:32000/callback
register application it will give us info
Client ID
dafe7cdcba496eef508b
Client Secret
817516cd3a3f279862510f588e219a17aab1c466
now 
export GITHUB_CLIENT_ID=dafe7cdcba496eef508b
export GITHUB_CLIENT_SECRET=817516cd3a3f279862510f588e219a17aab1c466

kubectl create secret \
    generic github-client \
    -n dex \
    --from-literal=client-id=$GITHUB_CLIENT_ID \
    --from-literal=client-secret=$GITHUB_CLIENT_SECRET
```
kubectl edit secrets github-client -n dex
now use nano /etc/kubernetes/manifests/kube-apiserver.yaml and add the lines after the last - --oidc 
kube-apiserver manifest file changes ( /etc/kubernetes/manifests/kube-apiserver.yaml):
```
    - --oidc-issuer-url=https://dex.psamman.com:32000
    - --oidc-client-id=example-app
    - --oidc-ca-file=/etc/kubernetes/pki/openid-ca.pem
    - --oidc-username-claim=email
    - --oidc-groups-claim=groups
```
now if u do
docker ps -a | grep kube-apiserver
deploy:
```
now we need to edit dex.yml and to make some change on the dns name dex.psamman.com

# - 'https://dex.newtech.academy:32000/callback'
      - 'https://dex.psamman.com:32000/callback'
      - 'http://178.62.90.238:5555/callback'   --> the master-node IP
kubectl create -f dex.yaml

kubectl get pods -n dex

```

deploy example app:
```
sudo apt-get install make golang-1.9
git clone https://github.com/coreos/dex.git
cd dex
git checkout v2.10.0
export PATH=$PATH:/usr/lib/go-1.9/bin
go get github.com/coreos/dex
make bin/example-app
export MY_IP=$(curl -s ifconfig.co)
./bin/example-app --issuer https://dex.psamman.com:32000 --issuer-root-ca /etc/kubernetes/pki/openid-ca.pem --listen http://${MY_IP}:5555 --redirect-uri http://${MY_IP}:5555/callback
```
now open second terminal


# Add user:
```
vim and add user in github ex:ammarqqqq@gmail.com
kubectl create -f user.yaml


from 1st terminal open copy the link http://104.248.239.115:5555 on thebrowser and take the token
copy the token
export TOKEN="dgdfgdfgdf"


press login andaccept the certificate 
#kubectl config set-credentials developer --token ${TOKEN}
kubectl config set-credentials developer --auth-provider=oidc --auth-provider-arg=idp-issuer-url=https://dex.psamman.com:32000 --auth-provider-arg=client-id=example-app --auth-provider-arg=idp-certificate-authority=/etc/kubernetes/pki/openid-ca.pem  --auth-provider-arg=id-token=${TOKEN}

kubectl config set-context dev-default --cluster=kubernetes --namespace=default --user=developer
kubectl config get-contexts 
kubectl config use-context dev-default (to switch to another token)
```
kubectl get pods will be work but not nodes no authorized to check nodes.

# Auto-renewal of token
For autorenewal, you need to share the client secret with the end-user (not recommended)
```
kubectl config set-credentials developer --auth-provider=oidc --auth-provider-arg=idp-issuer-url=https://dex.newtech.academy:32000 --auth-provider-arg=client-id=example-app --auth-provider-arg=idp-certificate-authority=/etc/kubernetes/pki/openid-ca.pem  --auth-provider-arg=id-token=${TOKEN} --auth-provider-arg=refresh-token=${REFRESH_TOKEN} --auth-provider-arg=client-secret=${CLIENT_SECRET}
```

# LDAP config

```
sudo apt-get -y install slapd ldap-utils gnutls-bin ssl-cert
sudo dpkg-reconfigure slapd
./gencert-ldap.sh
sudo ldapmodify -H ldapi:// -Y EXTERNAL -f ldap/certinfo.ldif
ldapadd -x -D cn=admin,dc=example,dc=com -W -f ldap/users.ldif 
```

Edit (with sudo) /etc/default/slapd
```
SLAPD_SERVICES="ldap:/// ldapi:/// ldaps:///"
```
and run:

```
sudo systemctl restart slapd.service
```

create LDAP CA secret and change configmap
```
cat /etc/ssl/certs/cacert.pem
kubectl edit configmap ldap-tls -n dex
kubectl apply -f configmap-ldap.yaml
kubectl edit deploy dex -n dex  # edit the ldap IP alias
```


