#!/bin/bash
##VARs
name_deploy=integradorsat-dp
namespace=pdn-salud

fecha=`date +"%Y%m%d"`
path="$name_deploy"_"$namespace"_"$fecha"
path_file=/tmp/pods

mkdir /tmp/"$path"

kubectl get po -n $namespace |grep $name_deploy |awk '{print $1}' > $path_file

for i in $(cat $path_file);
do
kubectl logs $i -n $namespace > /tmp/"$path"/"$i"_"$namespace"_"$fecha".log
done

