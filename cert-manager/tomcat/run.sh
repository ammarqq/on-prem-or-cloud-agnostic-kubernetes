#!/bin/bash
kubectl create -f tomcat.yml
#kubectl create -f issuer-staging.yml
kubectl create -f issuer-prod.yml
#kubectl create -f certificate-staging.yml
#kubectl apply -f tomcat-ingress-staging.yml
sleep 20

#kubectl delete -f certificate-staging.yml
sleep 10
kubectl create -f certificate-prod.yml
kubectl apply -f tomcat-ingress-prod.yml
