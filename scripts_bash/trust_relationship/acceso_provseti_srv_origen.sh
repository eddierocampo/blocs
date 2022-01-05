####################################################
##            Script para preparar el OS          ##
##            para el acceso con provseti         ##
##                   srv origen                   ##
##                                                ##
##          Preparado por Eddier Ocampo           ##
##              Infraestructura Base              ##
##                  SETI - 2020                   ##
####################################################

# Variables
password=P4ssw0rD2021*
server=192.168.122.61
path=/root

####################################################
# Generar la relación de confianza
sshpass -p "$password" ssh-copy-id -o StrictHostKeyChecking=no provseti@$server
ssh-copy-id -i $path/.ssh/id_rsa.pub provseti@$server
####################################################

