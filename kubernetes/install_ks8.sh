##
## Requisitos
## 3 vm con RHEL 7, master con 2GB RAM y 32GB en disco, 2 worker con 1GB de RAM y 12GB de disco.
# Selinux disabled
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

vi /etc/sysconfig/selinux
  :%s/SELINUX=enforcing/SELINUX=disabled/g

reboot
# hostname e IP estáticos
hostnamectl set-hostname 'k8s-master'
# Disabled firewalld o reglas agregadas
systemctl stop firewalld
systemctl disable firewalld
systemctl mask --now firewalld

firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250/tcp
firewall-cmd --permanent --add-port=10251/tcp
firewall-cmd --permanent --add-port=10252/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --reload
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
# edición del /etc/hosts en master y workers
vi /etc/hosts
  192.168.20.101	master01
  192.168.20.102	worker01
  192.168.20.103	worker02
#Agregar el repo de kubernetes al master
vi /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
# Disabled swap
swapoff -a

