#!/bin/bash
#Vars
deploy=deployment

mkdir ~/"$deploy"
kubectl get deploy |awk '{print $1}' > ~/"$deploy"