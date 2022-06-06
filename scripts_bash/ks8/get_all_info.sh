#!/bin/bash

### Vars
amb=pdn
grupo=core
fecha=`date +"%Y%m%d"`
path="$grupo"_"$amb"_"$fecha"

mkdir ~/"$path"
kubectl get ns | tr -s '[:blank:]' ',' > ~/"$path"/namespaces_"$path".txt
kubectl get deploy -A | tr -s '[:blank:]' ',' > ~/"$path"/deploy_"$path".txt
kubectl get po -A | tr -s '[:blank:]' ',' > ~/"$path"/pod_"$path".txt
kubectl get nodes -A | tr -s '[:blank:]' ',' > ~/"$path"/nodes_"$path".txt

tar -czf ~/"$grupo"_"$amb"_"$fecha".tar.gz ~/"$path"
