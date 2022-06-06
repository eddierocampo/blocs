#!/bin/bash

echo "systemctl stop kubelet"
systemctl stop kubelet
echo "systemctl disable kubelet"
systemctl disable kubelet
echo "systemctl stop docker"
systemctl stop docker
echo "systemctl disable docker"
systemctl disable docker
echo "systemctl stop chronyd"
systemctl stop chronyd
echo "systemctl disable chronyd"
systemctl disable chronyd

echo "timedatectl set-time 2022-04-15"
timedatectl set-time 2022-04-15