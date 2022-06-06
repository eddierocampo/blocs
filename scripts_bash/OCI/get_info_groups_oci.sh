#!/bin/bash

path=/tmp
file=$path/list_usersid


for i in $(cat $file);
do
  echo $i
  oci iam user list-groups --user-id $i |grep name
done
