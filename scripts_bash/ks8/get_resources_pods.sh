#!/bin/bash

#Vars
path_pods=/home/eocampo/scripts/files/list_pods.txt
path_result=/home/eocampo/scripts/files/result.txt

kubectl get pod -A | awk '{print $2, $1}' > $path_pods
sed 's/ / -n /' $path_pods

for i in $path_pods ;
do
  kubectl describe pod $i >> $path_result
done