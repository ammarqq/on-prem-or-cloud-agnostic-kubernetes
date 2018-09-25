# on-prem-or-cloud-agnostic-kubernetes
Setting up and running an on-prem or cloud agnostic Kubernetes cluster

This is the course material for the On-Prem or Cloud Agnostic Udemy Course on Udemy (see https://www.udemy.com/learn-devops-on-prem-or-cloud-agnostic-kubernetes/?couponCode=KUBERNETES_GIT)


kubeadm join 192.168.100.10:6443 --token gxvfd1.wo2wtz3zjydfkseh --discovery-token-ca-cert-hash sha256:fdc15b69bc8780b6a43c584c66bca4e586a6ca0df1fbab18ce5a02cb698b116d


to create token
kubeadm token create --help

kubeadm token create --print-join-command
