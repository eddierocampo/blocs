#!/bin/bash

name_pods=reaseguro
namespace=pdn-reactivas

name_deploy="$name_pods"-dp
fecha=`date +"%Y%m%d"`
path=~/logs/"$name_deploy"_"$namespace"_"$fecha"
file_pods=~/logs/pods

chmod 644 $file_pods
mkdir path
kubens $namespace
kubectl get po |awk '{print $2}' |grep "$name_deploy" > $file_pods

echo "Generando logs"
for i in $($file_pods);
  do
    echo "$i"
    kubectl logs $i > $path/$i
  done