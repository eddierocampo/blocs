#!/bin/bash
####################################################
##            Script para preparar el OS          ##
##            para el acceso con $usuario         ##
##                      cliente                   ##
##                                                ##
##          Preparado por Eddier Ocampo           ##
##              Infraestructura Base              ##
##                  SETI - 2020                   ##
####################################################
 
# Variables
usuario=provseti
grupo=wheel
 
####################################################
# Crear el usuario $usuario con su home
echo "Creando el usuario $usuario"
useradd -m $usuario
cat /etc/passwd |grep $usuario
ls -la /home/
mkdir /home/$usuario/.ssh
ls -la /home/$usuario
chmod 700 /home/$usuario/.ssh
chown $usuario:$grupo /home/$usuario/.ssh
touch /home/$usuario/.ssh/known_hosts /home/$usuario/.ssh/authorized_keys
chmod 600 /home/$usuario/.ssh/authorized_keys
chown $usuario:$grupo /home/$usuario/.ssh/known_hosts /home/$usuario/.ssh/authorized_keys
echo "P4ssw0rD2021*" | passwd --stdin $usuario
 
# Permisos de sudo al usuario $usuario
cp /etc/ssh/sshd_config /tmp/sshd_config"$(date +"%Y%m%d").bck"
echo "$usuario ALL=(ALL) ALL" >> /etc/sudoers
 
# Habilitando acceso por SSH
sed -i 's/PubkeyAuthentication no/#PubkeyAuthentication no/' /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
cat /etc/ssh/sshd_config |grep PermitEmptyPasswords
cat /etc/ssh/sshd_config |grep PubkeyAuthentication
systemctl restart sshd.service
systemctl status sshd.service
