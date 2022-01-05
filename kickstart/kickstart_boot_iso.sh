#!/bin/bash
##################################################
### Shell que genera una ISO de instalacion de ###
############ Red Hat 7 desatendida ###############
##################################################
### Fuente
### https://access.redhat.com/documentation/en/red-hat-enterprise-linux/7/paged/anaconda-customization-guide/3-customizing-the-boot-menu

### Variables
ISO="rhel-server-7.7-x86_64-dvd.iso"
DIR_MNT="/mnt"
DIR_CPY="/tmp/RHEL_OUT"
KST="rhel7.ks"
KICKSTAR="/home/norlan/${KST}"
DVD_OUT="rhel-server-7.7-x86_64-Hardening.iso"
VERSION="7.7"
LABEL_RH="RHEL-${VERSION}"

# 1. Tener o descargar la iso de redhat 7, y tener el fichero kickstart, en este caso se tiene rhel7.ks

# 2. Montarla y hacer una copia del contenido, agregando el fichero kickstar rhel7.ks

echo "Montando iso ${ISO} en ${DIR_MNT}" 
mount -o loop ${ISO} ${DIR_MNT}

echo "Creando directorio temporal para copiar el contenido de la ISO"
mkdir -p ${DIR_CPY}
cp -pRf ${DIR_MNT}/* ${DIR_CPY}

echo "Inyectando fichero kickstar"
cp ${KICKSTAR} ${DIR_CPY}/${KST}

# 3. Editar el fichero isolinux.cfg dentro de la copia y agregar las siguientes lineas "inst.ks=hd:LABEL=RHEL-7.3\x20Server.x86_64:/rhel7.ks"

echo "Editando el fichero isolinux.cfg"
chmod ugo+w ${DIR_CPY}/isolinux/isolinux.cfg

sed -i '66ilabel linux_ks' ${DIR_CPY}/isolinux/isolinux.cfg
sed -i '67imenu label ^Install Red Hat Enterprise Linux '"${VERSION}"' (Aseguramiento-SETI)' ${DIR_CPY}/isolinux/isolinux.cfg
sed -i '68i \ \ kernel vmlinuz' ${DIR_CPY}/isolinux/isolinux.cfg
sed -i '69i \ \ append initrd=initrd.img inst.stage2=hd:LABEL='"${LABEL_RH}"'\\\x\20Server.x86_64 quiet inst.ks=hd:LABEL='"${LABEL_RH}"'\\\x\20Server.x86_64:/'"${KST}"'' ${DIR_CPY}/isolinux/isolinux.cfg
sed -i '70i \ ' ${DIR_CPY}/isolinux/isolinux.cfg

chmod ugo-w ${DIR_CPY}/isolinux/isolinux.cfg

# label linux_ks
#  menu label ^Install Red Hat Enterprise Linux 7.3 (KickStar)
#  kernel vmlinuz
#  append initrd=initrd.img inst.stage2=hd:LABEL=RHEL-7.3\x20Server.x86_64 quiet inst.ks=hd:LABEL=RHEL-7.3\x20Server.x86_64:/rhel7.ks

# 4. Generar la ISO

echo "Generando ISO con el fichero kickstar"
genisoimage -U -r -v -T -J -joliet-long -V "${LABEL_RH} Server.x86_64" -volset "${LABEL_RH} Server.x86_64" -A "${LABEL_RH} Server.x86_64" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -o ${DVD_OUT} ${DIR_CPY}

# 5. Eliminando ficheros temporales
echo "Eliminando ficheros temporales"
rm -rf $DIR_CPY
umount -f ${DIR_MNT}
