#!/bin/bash
#VAR´s
namespace=pdn-reactivas

kubectl rollout restart deploy empresariales-apigw-dp
sleep 60
kubectl rollout restart deploy gc-empresariales-front-dp
sleep 60
kubectl rollout restart deploy ms-gcempresariales-front-dp
sleep 600
kubectl rollout restart deploy ohs-empresariales-dp
sleep 600