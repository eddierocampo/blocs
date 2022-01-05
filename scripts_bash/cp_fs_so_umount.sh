#!/bin/bash

# Copiado de archivos con cp
echo "Copiado de los archivos y la data con cp"
cd /var/log/audit/
/bin/cp -ax . /varlogaudit/
cd /var/log/
/bin/cp -ax . /varlog/
cd /var/tmp/
/bin/cp -ax . /vartmp/
cd /

# Validar estado de la copia
echo "Validando los FS"
du -sh /var/log/audit /varlogaudit
du -sh /var/log /varlog
du -sh /var/tmp /vartmp

# Desmontando los FS tmp
echo "Desmontando FS Temporales"
umount /varlogaudit
umount /varlog
umount /vartmp
df -h