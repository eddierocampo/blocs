#!/bin/bash
####################################################
##            Script para preparar el OS          ##
##          para el acceso con setideploy         ##
##                   srv origen                   ##
##                                                ##
##          Preparado por Eddier Ocampo           ##
##              Infraestructura Base              ##
##                  SETI - 2021                   ##
####################################################

# Variables
password=P4ssw0rD2021*
srv=192.168.122.61
path_home=/root
user=provseti

####################################################
# Generar la relación de confianza
for i in $(cat $srv);
do
sshpass -p "$password" ssh-copy-id -o StrictHostKeyChecking=no $user@$i
ssh-copy-id -i $path_home/.ssh/id_rsa.pub $user@$i
done
####################################################
