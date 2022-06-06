#!/bin/bash

name_pods=reaseguro
namespace=pdn-reactivas

name_deploy="$name_pods"-dp
fecha=`date +"%Y%m%d"`
path="$name_deploy"_"$namespace"_"$fecha"
path_file=/tmp/pods

kubens $namespace
kubectl get po |grep $name_deploy |awk '{print $1}' > $path_file

echo "INFO DE DEPLOYMENT"
kubectl get deploy $name_deploy -o=custom-columns='NAME_DEPLOY:metadata.labels.name,REPLICAS:status.replicas,EGV:metadata.annotations.azure-pipelines/pipeline,IP-PIPELINE:metadata.annotations.azure-pipelines/pipelineId,LASTRUN:metadata.annotations.azure-pipelines/run'

echo "STARTTIME"
kubectl get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.startTime}{"\n"}{end}' |grep $name_deploy

echo "CONFIGURACION LIMITES"
echo "NAME MEMLIM   MEREQ    SURA_JVM_HEAPSIZE   CPULIM   CPUREQ"
kubectl get pod -o=custom-columns='NAME:metadata.labels.name,MEMLIM:spec.containers[*].resources.limits.memory,MEREQ:spec.containers[*].resources.requests.memory,SURA_JVM_HEAPSIZE:{.spec.containers[*].env[?(@.name=="SURA_JVM_HEAPSIZE")].value},CPULIM:spec.containers[*].resources.limits.cpu,CPUREQ:spec.containers[*].resources.requests.cpu' |grep $name_pods

echo "IMAGE & TAG"
kubectl get pod -o=custom-columns='NAME:spec.containers[*].name,IMAGE:{.spec.containers[*].image}'|grep $name_deploy

echo "LAST STATE"
for i in $(cat $path_file);
  do
    echo "$i"
    kubectl get pod $i -o=custom-columns='EXITCODE:status.containerStatuses[*].lastState.terminated.exitCode,DATEFINISHED:status.containerStatuses[*].lastState.terminated.finishedAt,REASON:status.containerStatuses[*].lastState.terminated.reason'
  done

echo "ERRORS LOGS"
for i in $(cat $path_file);
  do
    echo "$i"
    kubectl logs $i |grep 'ERROR\|error\Error'
  done


