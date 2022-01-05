# Kickstart file for RHEL7
auth --enableshadow --passalgo=sha512
cdrom
cmdline
firstboot --enable
ignoredisk --only-use=sda
keyboard --vckeymap=latam --xlayouts='latam'
lang en_US.UTF-8
# Password root - S3t1r00tP4ss
rootpw --iscrypted $6$5fjoimtf$cgu4nZU2Oj8NPeSMcDXAf5VCwcJSjJK0XyCsUe16ACXmN4s.3KdhgBjvBQRS/0T1hllB3UtosKthhM8aehnwm1
services --enabled="chronyd"
timezone America/Bogota
# Password provseti - S3t1r00tP4ss
#user --name=provseti --password=$6$5fjoimtf$cgu4nZU2Oj8NPeSMcDXAf5VCwcJSjJK0XyCsUe16ACXmN4s.3KdhgBjvBQRS/0T1hllB3UtosKthhM8aehnwm1 --iscrypted --gecos="Usuario de instalacion SO"
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
clearpart --all --initlabel --drives=sda
part /boot --fstype="xfs" --ondisk=sda --size=512
part pv.535 --fstype="lvmpv" --ondisk=sda --size=51200 --grow
volgroup vgroot --pesize=4096 pv.535
logvol /  --fstype="xfs" --size=1024 --name=root --vgname=vgroot
logvol /home  --fstype="xfs" --size=5120 --name=home --vgname=vgroot --fsoptions="nodev"
logvol /opt  --fstype="xfs" --size=5120 --name=opt --vgname=vgroot
logvol /tmp  --fstype="xfs" --size=5120 --name=tmp --vgname=vgroot --fsoptions="nodev,nosuid,noexec"
logvol /usr  --fstype="xfs" --size=9216 --name=usr --vgname=vgroot
logvol /var  --fstype="xfs" --size=5120 --name=var --vgname=vgroot
logvol /var/log  --fstype="xfs" --size=5120 --name=var_log --vgname=vgroot
logvol /var/log/audit  --fstype="xfs" --size=5120 --name=var_log_audit --vgname=vgroot
logvol /var/tmp  --fstype="xfs" --size=5120 --name=var_tmp --vgname=vgroot --fsoptions="nodev,nosuid,noexec"
logvol swap  --fstype="swap" --size=4096 --name=swap --vgname=vgroot
reboot --eject

%packages
@core
kexec-tools
bash-completion
# 2.2.1.1 Ensure time synchronization is in use (Not Scored)
chrony
# Tools for VMware
open-vm-tools
# 1.3.1 Ensure AIDE is installed (Scored)
aide
# 3.4.1 Ensure TCP Wrappers is installerd (Scored)
tcp_wrappers
# Do not install firmware files
-alsa-firmware
-alsa-tools-firmware
-iwl100-firmware
-iwl1000-firmware
-iwl105-firmware
-iwl135-firmware
-iwl2000-firmware
-iwl2030-firmware
-iwl3160-firmware
-iwl3945-firmware
-iwl4965-firmware
-iwl5000-firmware
-iwl5150-firmware
-iwl6000-firmware
-iwl6000g2a-firmware
-iwl6000g2b-firmware
-iwl6050-firmware
-iwl7260-firmware
-iwl7265-firmware
%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%pre
%end

%post --log=/root/ks-post.log
##----------------------------------------------------------------------------------------------------
## Configuración de sudo para usuario provseti
#sed -i 's|root	ALL=(ALL) 	ALL|root	ALL=(ALL) 	ALL/a provseti	ALL=(ALL) 	ALL|g' /etc/sudoers
##----------------------------------------------------------------------------------------------------
## Configuraciones de aseguramiento CIS, Level 1 - Server
CISFILE=/etc/modprobe.d/CIS.conf
# 1.1.1.1 Ensure mounting of cramfs filesystems is disabled (Scored)
echo "install cramfs /bin/true" > ${CISFILE}
# 1.1.1.2 Ensure mounting of freevxfs filesystems is disabled (Scored)
echo "install freevxfs /bin/true" >> ${CISFILE}
# 1.1.1.3 Ensure mounting of jffs2 filesystems is disabled (Scored)
echo "install jffs2 /bin/true" >> ${CISFILE}
# 1.1.1.4 Ensure mounting of hfs filesystems is disabled (Scored)
echo "install hfs /bin/true" >> ${CISFILE}
# 1.1.1.5 Ensure mounting of hfsplus filesystems is disabled (Scored)
echo "install hfsplus /bin/true" >> ${CISFILE}
# 1.1.1.6 Ensure mounting of squashfs filesystems is disabled (Scored)
echo "install squashfs /bin/true" >> ${CISFILE}
# 1.1.1.7 Ensure mounting of udf filesystems is disabled (Scored)
echo "install udf /bin/true" >> ${CISFILE}
# 1.1.1.8 Ensure mounting of FAT filesystems is disabled (Scored)
echo "install vfat /bin/true" >> ${CISFILE}
# 1.1.2 Ensure separate partition exists for /tmp (Scored)
#NO APLICA ES NIVEL 2
# 1.1.3 Ensure nodev option set on /tmp partition (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.4 Ensure nosuid option set on /tmp partition (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.5 Ensure noexec option set on /tmp partition (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.6 Ensure separate partition exists for /var (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.7 Ensure separate partition exists for /var/tmp (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.8 Ensure nodev option set on /var/tmp partition (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.9 Ensure nosuid option set on /var/tmp partition (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.10 Ensure noexec option set on /var/tmp partition (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.11 Ensure separate partition exists for /var/log (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.12 Ensure separate partition exists for /var/log/audit (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.13 Ensure separate partition exists for /home (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.14 Ensure nodev option set on /home partition (Scored)
#Hecho en la creacion de volumenes de la plantilla
# 1.1.15 Ensure nodev option set on /dev/shm partition (Scored)
# 1.1.16 Ensure nosuid option set on /dev/shm partition (Scored)
# 1.1.17 Ensure noexec option set on /dev/shm partition (Scored)
sed -i '11ishmfs                   /dev/shm                tmpfs   defaults,nodev,nosuid,noexec 0 0' /etc/fstab 
# 1.1.18 Ensure nodev option set on removable media partitions (Not Scored)
# 1.1.19 Ensure nosuid option set on removable media partitions (Not Scored)
# 1.1.20 Ensure noexec option set on removable media partitions (Not Scored)
#Por defecto no hay puntos de montaje para medios removibles
# 1.1.21 Ensure sticky bit is set on all world-writable directories (Scored)
#Por defecto, la instalación no contiene directorios con permiso de escriutura para todos los usuarios
# 1.1.22 Disable Automounting (Scored)
#El servicio autofs no es instalado por defecto
# 1.2.1 Ensure package manager repositories are configured (Not Scored)
#La tarea de registro no se automatiza en la plantilla, debe realizarse manualmente
# 1.2.2 Ensure gpgcheck is globally activated (Scored)
#Por defecto, los repositorios de Red Hat siempre verifican las firmas de GPG
# 1.2.3 Ensure GPG keys are configured (Not Scored)
#Al registrarse el servidor con el portal de Red Hat e instalar un paquete, las llaves públicas se configuran automáticamente
# 1.2.4 Ensure Red Hat Network or Subscription Manager connection is configured (Not Scored)
#La tarea de registro no se automatiza en la plantilla, debe realizarse manualmente
# 1.2.5 Disable the rhnsd Daemon (Not Scored)
#NO APLICA ES NIVEL 2 - Deshabilitado por defecto
# 1.3.1 Ensure AIDE is installed (Scored)
#Paquete instalado en la lista de paquetes del kickstart
# 1.3.2 Ensure filesystem integrity is regularly checked (Scored)
echo "0 5 * * * /usr/sbin/aide --check" >> /var/spool/cron/root
# 1.4.1 Ensure permissions on bootloader config are configured (Scored)
chown root:root /boot/grub2/grub.cfg
chmod og-rwx /boot/grub2/grub.cfg
# 1.4.2 Ensure bootloader password is set (Scored)
#No se configura password porque al momento de una recuperacion del sistema se pueden presentar inconientes
# 1.4.3 Ensure authentication required for single user mode (Not Scored)
#Por defecto esta configuración se incluye desde RHEL 7
# 1.5.1 Ensure core dumps are restricted (Scored)
sed -i 's|# End of file|* hard core 0\n# End of file|g' /etc/security/limits.conf
echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf
# 1.5.2 Ensure XD/NX support is enabled (Not Scored)
#Por defecto desde RHEL 7 se habilita esta característica
# 1.5.3 Ensure address space layout randomization (ASLR) is enabled (Scored)
echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
# 1.5.4 Ensure prelink is disabled (Scored)
#Por defecto prelink no es instalado en RHEL 7.7
# 1.6.1.1 Ensure SELinux is not disabled in bootloader configuration (Scored)
#Por defecto RHEL 7.7 habilita esta característica
# 1.6.1.2 Ensure the SELinux state is enforcing (Scored)
#Por defecto RHEL 7.7 habilita esta característica
# 1.6.1.3 Ensure SELinux policy is configured (Scored)
#Por defecto RHEL 7.7 habilita esta característica
# 1.6.1.4 Ensure SETroubleshoot is not installed (Scored)
#Este paquete no se instala por defecto
# 1.6.1.5 Ensure the MCS Translation Service (mcstrans) is not installed (Scored)
#Este paquete no se instala por defecto
# 1.6.1.6 Ensure no unconfined daemons exist (Scored)
#Por defecto RHEL 7.7 habilita esta característica
# 1.6.2 Ensure SELinux is installed (Scored)
#Por defecto RHEL 7.7 habilita esta característica
# 1.7.1.1 Ensure message of the day is configured properly (Scored)
cat > /etc/motd << EOF
* * * * * * * * * * * * * * * B I E N V E N I D O * * * * * * * * * * * * * * *
*                                                                             *
* Este equipo es de uso Privado. Su ingreso solo le es permitido a usuarios   *
* autorizados. Todas las actividades son monitoreadas y su uso no autorizado  *
* o inapropiado puede ser causa de sanciones disciplinarias, acciones civiles *
* y/o penales. Al acceder a este equipo, el usuario acepta estos terminos y   *
* condiciones. Si usted no es un usuario autorizado o no esta de acuerdo con  *
* estas condiciones, debe salir de este equipo inmediatamente.                *
*                                                                             *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
EOF
# 1.7.1.2 Ensure local login warning banner is configured properly (Not Scored)
#Hay software que valida el sistema operativo mediante el archivo /etc/issue
#Su modificación puede generar inconvenientes
cat > /etc/issue << EOF
* * * * * * * * * * * * * * * B I E N V E N I D O * * * * * * * * * * * * * * *
*                                                                             *
* Este equipo es de uso Privado. Su ingreso solo le es permitido a usuarios   *
* autorizados. Todas las actividades son monitoreadas y su uso no autorizado  *
* o inapropiado puede ser causa de sanciones disciplinarias, acciones civiles *
* y/o penales. Al acceder a este equipo, el usuario acepta estos terminos y   *
* condiciones. Si usted no es un usuario autorizado o no esta de acuerdo con  *
* estas condiciones, debe salir de este equipo inmediatamente.                *
*                                                                             *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
EOF
# 1.7.1.3 Ensure remote login warning banner is configured properly (Not Scored)
cat > /etc/issue.net << EOF
* * * * * * * * * * * * * * * B I E N V E N I D O * * * * * * * * * * * * * * *
*                                                                             *
* Este equipo es de uso Privado. Su ingreso solo le es permitido a usuarios   *
* autorizados. Todas las actividades son monitoreadas y su uso no autorizado  *
* o inapropiado puede ser causa de sanciones disciplinarias, acciones civiles *
* y/o penales. Al acceder a este equipo, el usuario acepta estos terminos y   *
* condiciones. Si usted no es un usuario autorizado o no esta de acuerdo con  *
* estas condiciones, debe salir de este equipo inmediatamente.                *
*                                                                             *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
EOF
# 1.7.1.4 Ensure permissions on /etc/motd are configured (Not Scored)
chown root:root /etc/motd
chmod 644 /etc/motd
# 1.7.1.5 Ensure permissions on /etc/issue are configured (Scored)
chown root:root /etc/issue
chmod 644 /etc/issue
# 1.7.1.6 Ensure permissions on /etc/issue.net are configured (Not Scored)
chown root:root /etc/issue.net
chmod 644 /etc/issue.net
# 1.7.2 Ensure GDM login banner is configured (Scored)
#Por defecto, la instalación de RHEL 7 no incluye GDM
# 1.8 Ensure updates, patches, and additional security software are installed (Not Scored)
#Esta tarea no es realizada por la plantilla, debe realizarse manualmente
# 2.1.1 Ensure chargen services are not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye chargen
# 2.1.2 Ensure daytime services are not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye daytime
# 2.1.3 Ensure discard services are not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye discard
# 2.1.4 Ensure echo services are not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye echo
# 2.1.5 Ensure time services are not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye time
# 2.1.6 Ensure tftp server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye tftp
# 2.1.7 Ensure xinetd is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye xinetd
# 2.2.1.1 Ensure time synchronization is in use (Not Scored)
#Paquete instalado en la lista de paquetes del kickstart
# 2.2.1.2 Ensure ntp is configured (Scored)
#Por defecto la instalación de RHEL 7 no incluye ntp, se configura chrony
2.2.1.3 Ensure chrony is configured (Scored)
sed -i 's|0.rhel.pool.ntp.org|10.129.154.40|g' /etc/chrony.conf
sed -i 's|1.rhel.pool.ntp.org|10.129.154.41|g' /etc/chrony.conf
sed -i 's|2.rhel.pool.ntp.org|10.129.154.42|g' /etc/chrony.conf
sed -i '/rhel.pool.ntp.org/d' /etc/chrony.conf
#Configurar la ruta estática requerida de manera manual:
#https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html-single/Networking_Guide/index.html#sec-Configuring_Static_Routes_Using_nmcli
echo "OPTIONS=\"-u chrony\"" > /etc/sysconfig/chronyd
# 2.2.2 Ensure X Window System is not installed (Scored)
#Por defecto la instalación de RHEL 7 no incluye X
# 2.2.3 Ensure Avahi Server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye Avahi
# 2.2.4 Ensure CUPS is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye cups
# 2.2.5 Ensure DHCP Server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor DHCP
# 2.2.6 Ensure LDAP server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor LDAP
# 2.2.7 Ensure NFS and RPC are not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye NFS ni RPC
# 2.2.8 Ensure DNS Server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor DNS
# 2.2.9 Ensure FTP Server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor FTP
# 2.2.10 Ensure HTTP server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor HTTP
# 2.2.11 Ensure IMAP and POP3 server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor IMAP ni POP3
# 2.2.12 Ensure Samba is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor samba
# 2.2.13 Ensure HTTP Proxy Server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor de proxy
# 2.2.14 Ensure SNMP Server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor SNMP
# 2.2.15 Ensure mail transfer agent is configured for local-only mode (Scored)
#Por defecto la instalación de RHEL 7 incluye esta configuración
# 2.2.16 Ensure NIS Server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor NIS
# 2.2.17 Ensure rsh server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor rsh
# 2.2.18 Ensure talk server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor talk
# 2.2.19 Ensure telnet server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor telnet
# 2.2.20 Ensure tftp server is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor TFTP
# 2.2.21 Ensure rsync service is not enabled (Scored)
#Por defecto la instalación de RHEL 7 no incluye servidor rsync
# 2.3.1 Ensure NIS Client is not installed (Scored)
#Por defecto la instalación de RHEL 7 no incluye cliente NIS
# 2.3.2 Ensure rsh client is not installed (Scored)
#Por defecto la instalación de RHEL 7 no incluye cliente rsh
# 2.3.3 Ensure talk client is not installed (Scored)
#Por defecto la instalación de RHEL 7 no incluye cliente talk
# 2.3.4 Ensure telnet client is not installed (Scored)
#Por defecto la instalación de RHEL 7 no incluye cliente telnet
# 2.3.5 Ensure LDAP client is not installed (Scored)
#Por defecto la instalación de RHEL 7 no incluye cliente LDAP
# 3.1.1 Ensure IP forwarding is disabled (Scored)
echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf
# 3.1.2 Ensure packet redirect sending is disabled (Scored)
echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.conf
# 3.2.1 Ensure source routed packets are not accepted (Scored)
echo "net.ipv4.conf.all.accept_source_route = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route = 0" >> /etc/sysctl.conf
# 3.2.2 Ensure ICMP redirects are not accepted (Scored)
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
# 3.2.3 Ensure secure ICMP redirects are not accepted (Scored)
echo "net.ipv4.conf.all.secure_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.conf
# 3.2.4 Ensure suspicious packets are logged (Scored)
echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.conf
# 3.2.5 Ensure broadcast ICMP requests are ignored (Scored)
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf
# 3.2.6 Ensure bogus ICMP responses are ignored (Scored)
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.conf
# 3.2.7 Ensure Reverse Path Filtering is enabled (Scored)
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.conf
# 3.2.8 Ensure TCP SYN Cookies is enabled (Scored)
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
# 3.3.1 Ensure IPv6 router advertisements are not accepted (Scored)
echo "net.ipv6.conf.all.accept_ra = 0" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_ra = 0" >> /etc/sysctl.conf
# 3.3.2 Ensure IPv6 redirects are not accepted (Scored)
echo "net.ipv6.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
# 3.3.3 Ensure IPv6 is disabled (Not Scored)
echo "options ipv6 disable=1" >> /etc/modprobe.d/CIS.conf
# 3.4.1 Ensure TCP Wrappers is installed (Scored)
#Paquete instalado en la lista de paquetes del kickstart
# 3.4.2 Ensure /etc/hosts.allow is configured (Scored)
#No aplica configuracion. No se tienen definidos los servicios a configurar
# 3.4.3 Ensure /etc/hosts.deny is configured (Scored)
#No aplica configuracion. No se tienen definidos los servicios a denegar
# 3.4.4 Ensure permissions on /etc/hosts.allow are configured (Scored)
chown root:root /etc/hosts.allow
chmod 644 /etc/hosts.allow
# 3.4.5 Ensure permissions on /etc/hosts.deny are 644 (Scored)
chown root:root /etc/hosts.deny
chmod 644 /etc/hosts.deny
# 3.5.1 Ensure DCCP is disabled (Not Scored)
echo "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
# 3.5.2 Ensure SCTP is disabled (Not Scored)
echo "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
# 3.5.3 Ensure RDS is disabled (Not Scored)
echo "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
# 3.5.4 Ensure TIPC is disabled (Not Scored)
echo "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf
# 3.6.1 Ensure iptables is installed (Scored)
#El paquete iptables es instalado por defecto
# 3.6.2 Ensure default deny firewall policy (Scored)
#No aplicadas reglas de iptables
# 3.6.3 Ensure loopback traffic is configured (Scored)
#No aplicadas reglas de iptables
# 3.6.4 Ensure outbound and established connections are configured (Not Scored)
#No aplicadas reglas de iptables
# 3.6.5 Ensure firewall rules exist for all open ports (Scored)
#No aplicadas reglas de iptables
# 3.7 Ensure wireless interfaces are disabled (Not Scored)
#No se espera tener interfaces inalambricas en una maquina virtual
# 4.1.1.1 Ensure audit log storage size is configured (Not Scored)
sed -i 's|max_log_file = 8|max_log_file = 100|g' /etc/audit/auditd.conf
# 4.1.1.2 Ensure system is disabled when audit logs are full (Scored)
sed -i 's|space_left_action = SYSLOG|#space_left_action = email|g' /etc/audit/auditd.conf
sed -i 's|action_mail_acct = root|#action_mail_acct = root|g' /etc/audit/auditd.conf
sed -i 's|admin_space_left_action = SUSPEND|#admin_space_left_action = halt|g' /etc/audit/auditd.conf
# 4.1.1.3 Ensure audit logs are not automatically deleted (Scored)
sed -i 's|max_log_file_action = ROTATE|max_log_file_action = keep_logs|g' /etc/audit/auditd.conf
# 4.1.2 Ensure auditd service is enabled (Scored)
systemctl enable auditd
# 4.1.3 Ensure auditing for processes that start prior to auditd is enabled (Scored)
sed -i 's|rhgb quiet|rhgb quiet audit=1|g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
# 4.1.4 Ensure events that modify date and time information are collected (Scored)
echo "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b64 -S clock_settime -k time-change" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b32 -S clock_settime -k time-change" >> /etc/audit/rules.d/audit.rules
echo "-w /etc/localtime -p wa -k time-change" >> /etc/audit/rules.d/audit.rules
# 4.1.5 Ensure events that modify user/group information are collected (Scored)
echo "-w /etc/group -p wa -k identity" >> /etc/audit/rules.d/audit.rules
echo "-w /etc/passwd -p wa -k identity" >> /etc/audit/rules.d/audit.rules
echo "-w /etc/gshadow -p wa -k identity" >> /etc/audit/rules.d/audit.rules
echo "-w /etc/shadow -p wa -k identity" >> /etc/audit/rules.d/audit.rules
echo "-w /etc/security/opasswd -p wa -k identity" >> /etc/audit/rules.d/audit.rules
# 4.1.6 Ensure events that modify the system's network environment are collected (Scored)
echo "-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b32 -S sethostname -S setdomainname -k system-locale" >> /etc/audit/rules.d/audit.rules
echo "-w /etc/issue -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules
echo "-w /etc/issue.net -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules
echo "-w /etc/hosts -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules
echo "-w /etc/sysconfig/network -p wa -k system-locale" >> /etc/audit/rules.d/audit.rules
# 4.1.7 Ensure events that modify the system's Mandatory Access Controls are collected (Scored)
echo "-w /etc/selinux/ -p wa -k MAC-policy" >> /etc/audit/rules.d/audit.rules
# 4.1.8 Ensure login and logout events are collected (Scored)
echo "-w /var/log/lastlog -p wa -k logins" >> /etc/audit/rules.d/audit.rules
echo "-w /var/run/faillock/ -p wa -k logins" >> /etc/audit/rules.d/audit.rules
# 4.1.9 Ensure session initiation information is collected (Scored)
echo "-w /var/run/utmp -p wa -k session" >> /etc/audit/rules.d/audit.rules
echo "-w /var/log/wtmp -p wa -k session" >> /etc/audit/rules.d/audit.rules
echo "-w /var/log/btmp -p wa -k session" >> /etc/audit/rules.d/audit.rules
# 4.1.10 Ensure discretionary access control permission modification events are collected (Scored)
echo "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=1000 -F auid!=4294967295 -k perm_mod" >> /etc/audit/rules.d/audit.rules
# 4.1.11 Ensure unsuccessful unauthorized file access attempts are
echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=1000 -F auid!=4294967295 -k access" >> /etc/audit/rules.d/audit.rules
# 4.1.12 Ensure use of privileged commands is collected (Scored)
#No se incluye la auditoría de los binarios de VMware Tools suministrada por Claro debido a que no se recomienda instalar VMware Tools en RHEL7, sino open-vm-tools
#https://access.redhat.com/solutions/1694373
echo "-a always,exit -F path=/usr/bin/wall -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/fusermount -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/su -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/chage -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/gpasswd -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/newgrp -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/chfn -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/chsh -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/sudo -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/mount -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/crontab -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/umount -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/write -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/passwd -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/pkexec -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/bin/ssh-agent -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/sbin/pam_timestamp_check -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/sbin/unix_chkpwd -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/sbin/usernetctl -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/sbin/userhelper -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/sbin/netreport -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/sbin/postdrop -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/sbin/postqueue -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/lib/polkit-1/polkit-agent-helper-1 -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/lib64/dbus-1/dbus-daemon-launch-helper -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/libexec/utempter/utempter -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F path=/usr/libexec/openssh/ssh-keysign -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged" >> /etc/audit/rules.d/audit.rules
# 4.1.13 Ensure successful file system mounts are collected (Scored)
echo "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b32 -S mount -F auid>=1000 -F auid!=4294967295 -k mounts" >> /etc/audit/rules.d/audit.rules
# 4.1.14 Ensure file deletion events by users are collected (Scored)
echo "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 - F auid!=4294967295 -k delete" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 - F auid!=4294967295 -k delete" >> /etc/audit/rules.d/audit.rules
# 4.1.15 Ensure changes to system administration scope (sudoers) is collected (Scored)
echo "-w /etc/sudoers -p wa -k scope" >> /etc/audit/rules.d/audit.rules
echo "-w /etc/sudoers.d -p wa -k scope" >> /etc/audit/rules.d/audit.rules
# 4.1.16 Ensure system administrator actions (sudolog) are collected (Scored)
echo "-w /var/log/sudo.log -p wa -k actions" >> /etc/audit/rules.d/audit.rules
# 4.1.17 Ensure kernel module loading and unloading is collected (Scored)
echo "-w /var/log/sudo.log -p wa -k actions" >> /etc/audit/rules.d/audit.rules
echo "-w /sbin/rmmod -p x -k modules" >> /etc/audit/rules.d/audit.rules
echo "-w /sbin/modprobe -p x -k modules" >> /etc/audit/rules.d/audit.rules
echo "-a always,exit arch=b64 -S init_module -S delete_module -k modules" >> /etc/audit/rules.d/audit.rules
# 4.1.18 Ensure the audit configuration is immutable (Scored)
echo "-e 2" >> /etc/audit/rules.d/audit.rules
# 4.2.1.1 Ensure rsyslog Service is enabled (Scored)
systemctl enable rsyslog
# 4.2.1.2 Ensure logging is configured (Not Scored)
mv /etc/rsyslog.conf /etc/rsyslog.conf.bak
echo "*.emerg			:omusrmsg:*" > /etc/rsyslog.conf
echo "mail.*			-/var/log/mail" >> /etc/rsyslog.conf
echo "mail.info			-/var/log/mail.info" >> /etc/rsyslog.conf
echo "mail.warning		-/var/log/mail.warn" >> /etc/rsyslog.conf
echo "mail.err			/var/log/mail.err" >> /etc/rsyslog.conf
echo "news.crit			-/var/log/news/news.crit" >> /etc/rsyslog.conf
echo "news.err			-/var/log/news/news.err" >> /etc/rsyslog.conf
echo "news.notice		-/var/log/news/news.notice" >> /etc/rsyslog.conf
echo "*.=warning;*.=err		-/var/log/warn" >> /etc/rsyslog.conf
echo "*.crit			/var/log/warn" >> /etc/rsyslog.conf
echo "*.*;mail.none;news.none	-/var/log/messages" >> /etc/rsyslog.conf
echo "local0,local1.*		-/var/log/localmessages" >> /etc/rsyslog.conf
echo "local2,local3.*		-/var/log/localmessages" >> /etc/rsyslog.conf
echo "local4,local5.*		-/var/log/localmessages" >> /etc/rsyslog.conf
echo "local6,local7.*		-/var/log/localmessages" >> /etc/rsyslog.conf
# 4.2.1.3 Ensure rsyslog default file permissions configured (Scored)
echo "$FileCreateMode 0640" >> /etc/rsyslog.conf
# 4.2.1.4 Ensure rsyslog is configured to send logs to a remote log host (Scored)
#No se especifico server syslog
# 4.2.1.5 Ensure remote rsyslog messages are only accepted on designated log hosts. (Not Scored)
#Sólo aplica a servidores de logs, no a servidores regulares.
# 4.2.2.1 Ensure syslog-ng service is enabled (Scored)
#Se tiene instalado rsyslog no syslog-ng se debe definir uno de los dos segun 4.2.3 Ensure rsyslog or syslog-ng is installed
# 4.2.2.2 Ensure logging is configured (Not Scored)
#En RHEL 7 no se utiliza syslog-ng sino rsyslog
# 4.2.2.3 Ensure syslog-ng default file permissions configured (Scored)
#En RHEL 7 no se utiliza syslog-ng sino rsyslog
# 4.2.2.4 Ensure syslog-ng is configured to send logs to a remote log host (Not Scored)
#En RHEL 7 no se utiliza syslog-ng sino rsyslog
# 4.2.2.5 Ensure remote syslog-ng messages are only accepted on designated log hosts (Not Scored)
#En RHEL 7 no se utiliza syslog-ng sino rsyslog
# 4.2.3 Ensure rsyslog or syslog-ng is installed (Scored)
#Por defecto se instala rsyslog
# 4.2.4 Ensure permissions on all logfiles are configured (Scored)
find /var/log -type f -exec chmod g-wx,o-rwx {} +
# 4.3 Ensure logrotate is configured (Not Scored)
#Se incluye la configuración por defecto de logrotate
# 5.1.1 Ensure cron daemon is enabled (Scored)
systemctl enable crond
# 5.1.2 Ensure permissions on /etc/crontab are configured (Scored)
chown root:root /etc/crontab
chmod og-rwx /etc/crontab
# 5.1.3 Ensure permissions on /etc/cron.hourly are configured (Scored)
chown root:root /etc/cron.hourly
chmod og-rwx /etc/cron.hourly
# 5.1.4 Ensure permissions on /etc/cron.daily are configured (Scored)
chown root:root /etc/cron.daily
chmod og-rwx /etc/cron.daily
# 5.1.5 Ensure permissions on /etc/cron.weekly are configured (Scored)
chown root:root /etc/cron.weekly
chmod og-rwx /etc/cron.weekly
# 5.1.6 Ensure permissions on /etc/cron.monthly are configured (Scored)
chown root:root /etc/cron.monthly
chmod og-rwx /etc/cron.monthly
# 5.1.7 Ensure permissions on /etc/cron.d are configured (Scored)
chown root:root /etc/cron.d
chmod og-rwx /etc/cron.d
# 5.1.8 Ensure at/cron is restricted to authorized users (Scored)
rm -f /etc/cron.deny
rm -f /etc/at.deny
touch /etc/cron.allow
touch /etc/at.allow
chmod og-rwx /etc/cron.allow
chmod og-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow
# 5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured (Scored)
chown root:root /etc/ssh/sshd_config
chmod og-rwx /etc/ssh/sshd_config
# 5.2.2 Ensure SSH Protocol is set to 2 (Scored)
sed -i 's|#Protocol 2|Protocol 2|g' /etc/ssh/sshd_config
# 5.2.3 Ensure SSH LogLevel is set to INFO (Scored)
sed -i 's|#LogLevel INFO|LogLevel INFO|g' /etc/ssh/sshd_config
# 5.2.4 Ensure SSH X11 forwarding is disabled (Scored)
sed -i 's|X11Forwarding yes|X11Forwarding no|g' /etc/ssh/sshd_config
# 5.2.5 Ensure SSH MaxAuthTries is set to 4 or less (Scored)
sed -i 's|#MaxAuthTries 6|MaxAuthTries 3|g' /etc/ssh/sshd_config
# 5.2.6 Ensure SSH IgnoreRhosts is enabled (Scored)
sed -i 's|#IgnoreRhosts yes|IgnoreRhosts yes|g' /etc/ssh/sshd_config
# 5.2.7 Ensure SSH HostbasedAuthentication is disabled (Scored)
sed -i 's|#HostbasedAuthentication no|HostbasedAuthentication no|g' /etc/ssh/sshd_config
# 5.2.8 Ensure SSH root login is disabled (Scored)
#sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
# 5.2.9 Ensure SSH PermitEmptyPasswords is disabled (Scored)
sed -i 's|#PermitEmptyPasswords no|PermitEmptyPasswords no|g' /etc/ssh/sshd_config
# 5.2.10 Ensure SSH PermitUserEnvironment is disabled (Scored)
sed -i 's|#PermitUserEnvironment no|PermitUserEnvironment no|g' /etc/ssh/sshd_config
# 5.2.11 Ensure only approved ciphers are used (Scored)
sed -i '38iCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr' /etc/ssh/sshd_config
# 5.2.12 Ensure only approved MAC algorithms are used (Scored)
echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com" >> /etc/ssh/sshd_config
echo "KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256" >> /etc/ssh/sshd_config
# 5.2.13 Ensure SSH Idle Timeout Interval is configured (Scored)
sed -i 's|#ClientAliveInterval 0|ClientAliveInterval 300|g' /etc/ssh/sshd_config
sed -i 's|#ClientAliveCountMax 3|ClientAliveCountMax 0|g' /etc/ssh/sshd_config
# 5.2.14 Ensure SSH LoginGraceTime is set to one minute or less (Scored)
sed -i 's|#LoginGraceTime 2m|LoginGraceTime 60|g' /etc/ssh/sshd_config
# 5.2.15 Ensure SSH access is limited (Scored)
echo "AllowUsers root provseti" >> /etc/ssh/sshd_config
# 5.2.16 Ensure SSH warning banner is configured (Scored)
sed -i 's|#Banner none|Banner /etc/issue.net|g' /etc/ssh/sshd_config
# 5.3.1 Ensure password creation requirements are configured (Scored)
sed -i 's|# minlen = 9|minlen = 14|g' /etc/ssh/sshd_config
sed -i 's|# dcredit = 1|dcredit = -1|g' /etc/ssh/sshd_config
sed -i 's|# ucredit = 1|ucredit = -1|g' /etc/ssh/sshd_config
sed -i 's|# lcredit = 1|lcredit = -1|g' /etc/ssh/sshd_config
sed -i 's|# ocredit = 1|ocredit = -1|g' /etc/ssh/sshd_config
# 5.3.2 Ensure lockout for failed password attempts is configured (Scored)
sed -i 's|auth        sufficient    pam_unix.so nullok try_first_pass|auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900\nauth [success=1 default=bad] pam_unix.so\nauth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900\nauth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900|g' /etc/pam.d/password-auth
sed -i 's|auth        sufficient    pam_unix.so nullok try_first_pass|auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900\nauth [success=1 default=bad] pam_unix.so\nauth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900\nauth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900|g' /etc/pam.d/system-auth
# 5.3.3 Ensure password reuse is limited (Scored)
sed -i 's|use_authtok|use_authtok remember=5|g' /etc/pam.d/password-auth
sed -i 's|use_authtok|use_authtok remember=5|g' /etc/pam.d/system-auth
# 5.3.4 Ensure password hashing algorithm is SHA-512 (Scored)
#Establecido inicialmente en el kickstart en la seccion de autenticación (línea 2)
# 5.4.1.1 Ensure password expiration is 90 days or less (Scored)
sed -i 's|PASS_MAX_DAYS	99999|PASS_MAX_DAYS	90|g' /etc/login.defs
# 5.4.1.2 Ensure minimum days between password changes is 7 or more (Scored)
sed -i 's|PASS_MIN_DAYS	0|PASS_MIN_DAYS	7|g' /etc/login.defs
# 5.4.1.3 Ensure password expiration warning days is 7 or more (Scored)
#La configuración por defecto de RHEL 7 es de 7 dias
# 5.4.1.4 Ensure inactive password lock is 30 days or less (Scored)
useradd -D -f 30
chage --inactive 30 root
chage --inactive 30 provseti
# 5.4.2 Ensure system accounts are non-login (Scored)
#Por defecto todas las cuentas de sistema tienen restringido el login
# 5.4.3 Ensure default group for the root account is GID 0 (Scored)
#Esta es la configuración por defecto de RHEL 7
# 5.4.4 Ensure default user umask is 027 or more restrictive (Scored)
sed -i 's|umask 022|umask 027|g' /etc/bashrc
sed -i 's|umask 022|umask 027|g' /etc/profile
# 5.5 Ensure root login is restricted to system console (Not Scored)
#No se configura no aplica por politicas de data
# 5.6 Ensure access to the su command is restricted (Scored)
sed -i 's|#auth		required	pam_wheel.so use_uid|auth		required	pam_wheel.so use_uid|g' /etc/pam.d/su
usermod -aG wheel root
# 6.1.2 Ensure permissions on /etc/passwd are configured (Scored)
chown root:root /etc/passwd
chmod 644 /etc/passwd
# 6.1.3 Ensure permissions on /etc/shadow are configured (Scored)
chown root:root /etc/shadow
chmod 000 /etc/shadow
# 6.1.4 Ensure permissions on /etc/group are configured (Scored)
chown root:root /etc/group
chmod 644 /etc/group
# 6.1.5 Ensure permissions on /etc/gshadow are configured (Scored)
chown root:root /etc/gshadow
chmod 000 /etc/gshadow
# 6.1.6 Ensure permissions on /etc/passwd- are configured (Scored)
chown root:root /etc/passwd-
chmod 600 /etc/passwd-
# 6.1.7 Ensure permissions on /etc/shadow- are configured (Scored)
chown root:root /etc/shadow-
chmod 600 /etc/shadow-
# 6.1.8 Ensure permissions on /etc/group- are configured (Scored)
chown root:root /etc/group-
chmod 600 /etc/group-
# 6.1.9 Ensure permissions on /etc/gshadow- are configured (Scored)
chown root:root /etc/gshadow-
chmod 600 /etc/gshadow-
# 6.1.10 Ensure no world writable files exist (Scored)
#Por defecto, la instalación realizada no contine eningún archivo con permisos de escritura para todos los usuarios
# 6.1.11 Ensure no unowned files or directories exist (Scored)
#Por defecto, la instalación realizada no contine eningún archivo sin usuario propietario
# 6.1.12 Ensure no ungrouped files or directories exist (Scored)
#Por defecto, la instalación realizada no contine eningún archivo sin grupo propietario
# 6.1.13 Audit SUID executables (Not Scored)
#El listado de binarios con permiso SUID que se incluyen por defecto en la instalación es:
#[root@rhel7 ~]# df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -4000
#/usr/bin/fusermount
#/usr/bin/su
#/usr/bin/chage
#/usr/bin/gpasswd
#/usr/bin/newgrp
#/usr/bin/chfn
#/usr/bin/chsh
#/usr/bin/sudo
#/usr/bin/mount
#/usr/bin/crontab
#/usr/bin/umount
#/usr/bin/passwd
#/usr/bin/pkexec
#/usr/sbin/pam_timestamp_check
#/usr/sbin/unix_chkpwd
#/usr/sbin/usernetctl
#/usr/sbin/userhelper
#/usr/lib/polkit-1/polkit-agent-helper-1
#/usr/lib64/dbus-1/dbus-daemon-launch-helper
#[root@rhel7 ~]# 
# 6.1.14 Audit SGID executables (Not Scored)
#El listado de binarios con permiso SGID que se incluyen por defecto en la instalación es:
#[root@rhel7 ~]# df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -2000
#/usr/bin/wall
#/usr/bin/write
#/usr/bin/ssh-agent
#/usr/sbin/netreport
#/usr/sbin/postdrop
#/usr/sbin/postqueue
#/usr/libexec/utempter/utempter
#/usr/libexec/openssh/ssh-keysign
#[root@rhel7 ~]# 
# 6.2.1 Ensure password fields are not empty (Scored)
#Por defecto, todos los usuarios tienen una contraseña asignada, o están bloqueados
# 6.2.2 Ensure no legacy "+" entries exist in /etc/passwd (Scored)
#La instalación realizada no contiene entradas legadas
# 6.2.3 Ensure no legacy "+" entries exist in /etc/shadow (Scored)
#La instalación realizada no contiene entradas legadas
# 6.2.4 Ensure no legacy "+" entries exist in /etc/group (Scored)
#La instalación realizada no contiene entradas legadas
# 6.2.5 Ensure root is the only UID 0 account (Scored)
#Por defecto, ningún usuario diferente del root tiene UID 0
# 6.2.6 Ensure root PATH Integrity (Scored)
sed -i "/PATH/d" /root/.bash_profile
# 6.2.7 Ensure all users' home directories exist (Scored)
#Por defeto, todos los directorios home de todos los usuarios de la instalación existen
# 6.2.8 Ensure users' home directories permissions are 750 or more restrictive (Scored)
#Por defecto, esta es la configuración de RHEL 7
# 6.2.9 Ensure users own their home directories (Scored)
#Por defecto, esta es la configuración de RHEL 7
# 6.2.10 Ensure users' dot files are not group or world writable (Scored)
#Por defecto, esta es la configuración de RHEL 7
# 6.2.11 Ensure no users have .forward files (Scored)
#Por defecto, ningún usuario tiene este archivo
# 6.2.12 Ensure no users have .netrc files (Scored)
#Por defecto, ningún usuario tiene este archivo
# 6.2.13 Ensure users' .netrc Files are not group or world accessible (Scored)
#Por defecto, ningún usuario tiene este archivo
# 6.2.14 Ensure no users have .rhosts files (Scored)
#Por defecto, ningún usuario tiene este archivo
# 6.2.15 Ensure all groups in /etc/passwd exist in /etc/group (Scored)
#Por defecto, todos los grupos existen en ambos archivos
# 6.2.16 Ensure no duplicate UIDs exist (Scored)
#Por defecto, ningún UID está duplicado
# 6.2.17 Ensure no duplicate GIDs exist (Scored)
#Por defecto, ningún GID está duplicado
# 6.2.18 Ensure no duplicate user names exist (Scored)
#Por defecto ningún usuario está duplicado 
# 6.2.19 Ensure no duplicate group names exist (Scored)
#Por defecto ningún grupo está duplicado
##----------------------------------------------------------------------------------------------------
##Script encargado de asignar la configuración de red
(
cat <<EOF
#!/bin/bash
##Asignar una terminal libre para visualizar la salida de los comandos
exec < /dev/tty6 > /dev/tty6 2> /dev/tty6
chvt 6
##----------------------------------------------------------------------------------------------------
##Variables de datos de red del servidor
direccionip=""
dominio=""
mascara=""
gateway=""
dns1=""
dns2=""
nic=""
ip_repo=""

echo ""
echo "=========== DIRECCIONAMIENTO IP DEL SERVIDOR ==========="
echo ""

##Eliminar las conexiones existentes actualmente
rm -f /etc/sysconfig/network-scripts/ifcfg-e*
nmcli connection reload

###Listar las interfaces de red
NICS=\$(nmcli device status | grep ethernet | sort | cut -d\\  -f1 )

for nic in \$NICS; do

  # Obtener la direccion MAC de la interfaz
  mac=\$(nmcli -t device show \$nic | grep "HWADDR" | cut -d: -f2,3,4,5,6,7)

  ##Crear la conexión base
  nmcli con add con-name \$nic ifname \$nic type ethernet
  
  echo ""
  echo "### Configurando interface \$nic con MAC: \$mac ###"
  echo ""
  read -p "Ingrese la IP a asignar a la interfaz \$nic o ENTER para DHCP: " direccionip
  if [ ! "x\$direccionip" = "x" ]; then
    read -p "Ingrese la mascara de red a asignar a la interfaz en formato CIDR (Ej.: 24): " mascara
    read -p "Ingrese el default gateway a asignar a la interfaz o ENTER para ninguno: " gateway
    read -p "Ingrese el DNS primario a asignar a la interfaz o ENTER para ninguno: " dns1
    read -p "Ingrese el DNS secundario a asignar a la interfaz, o ENTER para ninguno: " dns2
    echo ""
  
    if [ ! "x\$direccionip" = "x" -a ! "x\$mascara" = "x" ]; then
      echo "Configurando direccion IP fija..."
      #Direccion IP y máscara de subred
      nmcli con mod \$nic ipv4.addresses \$direccionip/\$mascara

      ##IP fija 
      nmcli con mod \$nic ipv4.method manual
    fi
  
    ##Default gateway
    if [ ! "x\$gateway" = "x" ]; then
      echo "Configurando default gateway..."
      nmcli con mod \$nic ipv4.gateway \$gateway
    fi

    ##DNS 
    if [ ! "x\$dns1" = "x" ]; then
      echo "Configurando DNS1..."
      nmcli con mod \$nic ipv4.dns "\$dns1"
    fi

    ##DNS 
    if [ ! "x\$dns2" = "x" ]; then
      echo "Configurando DNS2..."
      nmcli con mod \$nic +ipv4.dns "\$dns2"
    fi
  fi

  ##Conectar automaticamente
  nmcli con mod \$nic connection.autoconnect true

  ##Aplicar la configuracion
  nmcli con up \$nic
  echo "======================================================================="
done

echo ""
echo "=========== NOMBRE DNS DEL SERVIDOR ==========="
echo ""
read -p "Ingrese el hostname a asignar al nuevo servidor sin incluir el dominio: " hostname
read -p "Ingrese el dominio a asignar al servidor: " dominio

hostname=\$(echo \$hostname | tr '[:upper:]' '[:lower:]' | cut -d\. -f1)
dominio=\$(echo \$dominio | tr '[:upper:]' '[:lower:]')

##Hostname
hostnamectl set-hostname \$hostname.\$dominio
echo "======================================================================="

echo ""
echo "=========== DIRECCION IP DEL REPOSITORIO ==========="
echo ""
read -p "Ingrese la direccion IP para el repositorio de paquetes rpm: " ip_repo

echo "[Repo_local_ath]" > /etc/yum.repos.d/Repo_local_ath 
echo "name='Red Hat Enterprise Linux 7 Server (RPMs)'" >> /etc/yum.repos.d/Repo_local_ath
echo "baseurl=https:/$ip_repo/reporhn/rhel-7-server-rpms" >> /etc/yum.repos.d/Repo_local_ath
echo "enable=1" >> /etc/yum.repos.d/Repo_local_ath
echo "gpgcheck=0" >> /etc/yum.repos.d/Repo_local_ath
echo "sslverify=0" >> /etc/yum.repos.d/Repo_local_ath

##Eliminar este script del sistema así como del arranque de la máquina
systemctl disable deployment.service
rm -f /etc/systemd/system/deployment.service
rm -f /opt/deployment.sh
EOF
) > /opt/deployment.sh
chmod 0700 /opt/deployment.sh
##FIN DEL SCRIPT

##----------------------------------------------------------------------------------------------------
##Crear el servicio que iniciará el script al iniciar la máquina por primera vez
(
cat <<EOF
[Unit]
Description=Deployment service
After=network.target
Before=sshd.service systemd-logind.service getty@tty1.service

[Service]
Type=oneshot
TTYPath=/dev/tty13
ExecStartPre=/usr/bin/chvt 13
ExecStart=/opt/deployment.sh
ExecStartPost=/usr/bin/chvt 1
TimeoutStartSec=0
StandardInput=tty
TTYVHangup=yes
TTYVTDisallocate=yes

[Install]
WantedBy=default.target
RequiredBy=sshd.service systemd-logind.service getty@tty1.service
EOF
) > /etc/systemd/system/deployment.service
systemctl reload deployment.service
systemctl enable deployment.service
##----------------------------------------------------------------------------------------------------
# Reiniciar el servidor para que quede listo
reboot
##----------------------------------------------------------------------------------------------------
%end
