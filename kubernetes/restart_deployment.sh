#!/bin/bash
##VARs
path_file=/tmp/name_deploy_completador

kubectl get po -n pdn-seguros |grep completador |awk '{print $1}' > $path_file

for i in $(cat $path_file);
do
kubectl delete po $i -n pdn-seguros
sleep 30
kubectl get po -n pdn-seguros |grep completador
done
