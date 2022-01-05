#!/bin/bash
##################################################
### Shell que genera una ISO de instalacion de ###
########### Oracle Linux 7 desatendida ###########
##################################################
### Fuente
### https://access.redhat.com/documentation/en/red-hat-enterprise-linux/7/paged/anaconda-customization-guide/3-customizing-the-boot-menu

### Variables
ISO=oracle-linux-server-7.5-x86_64.iso
DIR_MNT="/mnt"
DIR_CPY="/tmp/OEL_OUT"
VERSION="7.5"
KST="rhel7.ks"
KICKSTAR="/home/norlan/${KST}"
DVD_OUT="oracle-linux-server-${VERSION}-x86_64-Hardening.iso"
LABEL_RH="OL-${VERSION}"


# 1. Tener o descargar la iso de redhat 7, y tener el fichero kickstart, en este caso se tiene rhel7.ks

# 2. Montarla y hacer una copia del contenido, agregando el fichero kickstar rhel7.ks

echo "Montando iso ${ISO} en ${DIR_MNT}" 
mount -o loop ${ISO} ${DIR_MNT}

echo "Creando directorio temporal para copiar el contenido de la ISO"
mkdir -p ${DIR_CPY}
cp -pRf ${DIR_MNT}/* ${DIR_CPY}

echo "Inyectando fichero kickstar"
cp ${KICKSTAR} ${DIR_CPY}/rhel7.ks

# 3. Editar el fichero isolinux.cfg dentro de la copia y agregar las siguientes lineas "inst.ks=hd:LABEL=RHEL-7.3\x20Server.x86_64:/rhel7.ks"

echo "Editando el fichero isolinux.cfg"
chmod ugo+w ${DIR_CPY}/isolinux/isolinux.cfg

sed -i '67ilabel linux_ks' ${DIR_CPY}/isolinux/isolinux.cfg
sed -i '68imenu label ^Install Oracle Linux '"${VERSION}"' (Aseguramiento-SETI)' ${DIR_CPY}/isolinux/isolinux.cfg
sed -i '69i \ \ kernel vmlinuz' ${DIR_CPY}/isolinux/isolinux.cfg
sed -i '70i \ \ append initrd=initrd.img inst.stage2=hd:LABEL='"${LABEL_RH}"'\\\x\20Server.x86_64 quiet inst.ks=hd:LABEL='"${LABEL_RH}"'\\\x\20Server.x86_64:/'"${KST}"'' ${DIR_CPY}/isolinux/isolinux.cfg
sed -i '71i \ ' ${DIR_CPY}/isolinux/isolinux.cfg

chmod ugo-w ${DIR_CPY}/isolinux/isolinux.cfg

# label linux_ks
#  menu label ^Install Oracle Linux 7.3 (KickStart)
#  kernel vmlinuz
#  append initrd=initrd.img inst.stage2=hd:LABEL=RHEL-7.3\x20Server.x86_64 quiet inst.ks=hd:LABEL=RHEL-7.3\x20Server.x86_64:/rhel7.ks

# 4. Generar la ISO

echo "Generando ISO con el fichero kickstar"
genisoimage -U -r -v -T -J -joliet-long -V "${LABEL_RH} Server.x86_64" -volset "${LABEL_RH} Server.x86_64" -A "${LABEL_RH} Server.x86_64" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -o ${DVD_OUT} ${DIR_CPY}

rm -rf $DIR_CPY
umount -f ${DIR_MNT}

