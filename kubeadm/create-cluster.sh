#!/bin/bash

# run on master node / controlplane
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=10.33.168.9 --apiserver-cert-extra-sans=controlplane


mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubeadm token create --print-join-command

# this will generate a token 
echo "ssh node-name"


# run the token on worker node

# to insatll flannel network plugin
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

