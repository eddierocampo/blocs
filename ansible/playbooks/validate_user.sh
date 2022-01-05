#!/bin/bash
# vars
inventario=/etc/ansible/inventarios/pci.inventory.yml
grupo=evidenciaspci


ansible -i $inventario -m copy -a 'src=/home/provseti/scripts/user_activated.sh dest=/home/provseti/user_activated.sh mode=+x' $grupo
ansi