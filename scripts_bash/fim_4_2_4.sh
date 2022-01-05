#!/bin/bash
# Variables

ambiente=devops
inventario=/etc/ansible/inventarios/pci.inventory.yml

echo "4.2.4 Ensure Permissions on All Logfiles Are Configured"
echo "COPIANDO LOS SCRIPTS"
ansible -i $inventario -m copy -a 'src=/home/provseti/scripts/4_2_4_script_allfiles.sh dest=/home/provseti/scripts/4_2_4_script_allfiles.sh mode=+x' $ambiente
ansible -i $inventario -m copy -a 'src=/home/provseti/scripts/4_2_4_change_640_file.sh dest=/home/provseti/4_2_4_change_640_file.sh mode=+x' $ambiente
echo "EJECUTANDO SCRIPT HALLAR /var/log/ CON + PERMISOS"
ansible -i $inventario -m shell -a '/bin/bash /home/provseti/4_2_4_script_allfiles.sh > /home/provseti/alllogsperrmission.log' $ambiente
echo "ARCHIVOS A CAMBIAR"
ansible -i $inventario -m shell -a 'cat /home/provseti/alllogsperrmission.log' $ambiente
echo "EVIDENCIA DEL CAMBIO"
ansible -i $inventario -m shell -a '/bin/bash /home/provseti/4_2_4_change_all_log.sh' $ambiente
echo "ELIMANDO LOS ARCHIVOS DE BASE"
ansible -i $inventario -m file -a 'path=/home/provseti/scripts/4_2_4_script_allfiles.sh state=absent' $ambiente
ansible -i $inventario -m file -a 'path=/home/provseti/4_2_4_change_640_file.sh state=absent' $ambiente