#!/bin/bash
####################################################
##            Script para preparar OS             ##
##                                                ##
##          Preparado por Eddier Ocampo           ##
##              Infraestructura Base              ##
##                  SETI - 2020                   ##
####################################################

# Variables
path=/dev/xvdf1


# Creación del particionamiento, discos, formateo
# de particiones, creación carpetas temprales
echo "Creando Particionamiento"
pvcreate $path
vgcreate vgroot $path
vgdisplay

lvcreate -n lvtmp --size 5G vgroot
lvcreate -n lvvar --size 5G vgroot
lvcreate -n lvhome --size 10G vgroot
lvcreate -n lvvartmp --size 10G vgroot
lvcreate -n lvvarlog --size 5G vgroot
lvcreate -n lvvarlogaudit --size 5G vgroot

echo "Formatiando en xfs"
mkfs.xfs /dev/vgroot/lvtmp
mkfs.xfs /dev/vgroot/lvvar
mkfs.xfs /dev/vgroot/lvhome
mkfs.xfs /dev/vgroot/lvvartmp
mkfs.xfs /dev/vgroot/lvvarlog
mkfs.xfs /dev/vgroot/lvvarlogaudit

echo "Creando las carpetas temporales"
mkdir /tmp2 /var1 /home1 /vartmp /varlog /varlogaudit

echo "Montando las particiones temporales"
mount /dev/vgroot/lvtmp /tmp2
mount /dev/vgroot/lvhome /home1
mount /dev/vgroot/lvvar /var1
mount /dev/vgroot/lvvartmp /vartmp
mount /dev/vgroot/lvvarlog /varlog
mount /dev/vgroot/lvvarlogaudit /varlogaudit
df -hP

# Copiado de archivos con cp
echo "Copiado de los archivos y la data con cp"
cd /var/
/bin/cp -ax . /var1/
cd /var/tmp/
/bin/cp -ax . /vartmp/
cd /var/log/
/bin/cp -ax . /varlog/
cd /var/log/audit/
/bin/cp -ax . /varlogaudit/
cd /home
/bin/cp -ax . /home1/
cd /tmp/
/bin/cp -ax . /tmp2/
cd /

# Validar estado de la copia
echo "Validando los FS"
du -sh /var /var1
du -sh /var/tmp /vartmp
du -sh /var/log /varlog
du -sh /var/log/audit /varlogaudit
du -sh /home /home1
du -sh /tmp /tmp2

# Desmontando los FS tmp
echo "Desmontando FS Temporales"
umount /home1
umount /tmp2
umount /varlogaudit
umount /varlog
umount /vartmp
umount /var1

# Modificando el /etc/fstab
echo "Modificando el /etc/fstab"
echo "Backup del /etc/fstab"
cp /etc/fstab /scripts/fstab"$(date +"%Y%m%d").bck"
ls -la /scripts/ |grep fstab
echo '/dev/vgroot/lvtmp           /tmp                xfs     nodev,nosuid,noexec   0 0' >> /etc/fstab
echo '/dev/vgroot/lvhome          /home               xfs     nodev                 0 0' >> /etc/fstab
echo '/dev/vgroot/lvvar           /var                xfs     defaults              0 0' >> /etc/fstab
echo '/dev/vgroot/lvvartmp        /var/tmp            xfs     nodev,nosuid,noexec   0 0' >> /etc/fstab
echo '/dev/vgroot/lvvarlog        /var/log            xfs     defaults              0 0' >> /etc/fstab
echo '/dev/vgroot/lvvarlogaudit   /var/log/audit      xfs     defaults              0 0' >> /etc/fstab
echo 'shmfs                       /dev/shm            tmpfs   nodev,nosuid,noexec   0 0' >> /etc/fstab
cat /etc/fstab
mount -a
df -hP