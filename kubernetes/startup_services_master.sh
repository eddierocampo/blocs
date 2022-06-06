#!/bin/bash

echo "systemctl start docker"
systemctl start docker
echo "systemctl enable docker"
systemctl enable docker
echo "systemctl start kubelet"
systemctl start kubelet
echo "systemctl enable kubelet"
systemctl enable kubelet
echo "systemctl start chronyd"
systemctl enable chronyd
