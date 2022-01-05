#!/bin/bash
for i in `cat /home/provseti/alllogsperrmission.log |awk '{print $4}'`;
do
chmod 640 $i
ls -la $i
done