#!/bin/bash
cd /opt/ibm-cloud-private-3.2.1/cluster/

export MASTER_IP='10.208.25.155'
kubectl config set-cluster 911cluster --server=https://10.208.25.155:8001 --insecure-skip-tls-verify=true
kubectl config set-context 911cluster --cluster=911cluster
kubectl config set-credentials 911cluster --client-certificate=./cfc-certs/kubernetes/kubecfg.crt --client-key=./cfc-certs/kubernetes/kubecfg.key
kubectl config set-context 911cluster --user=911cluster  --namespace=kube-system
kubectl config use-context 911cluster
kubectl get nodes