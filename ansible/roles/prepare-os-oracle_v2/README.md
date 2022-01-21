# tasks file for seti.ora_12c_7
#################################
## Oracle 12c Release 2 Standalone/rac Server on Red Hat Enterprise Linux 7.X
## 1. Hardware Details
## CPU 16 Core
## RAM 48 G
## 2 NIC/Gigabit
## 2 HBA 8Gbit

## 2. Disk Details
### FS SO.
## /         15 GB
## /dev/shm  24 GB
## /boot    512 MB
## /tmp       8 GB
## /usr       5 GB
## /var       8 GB
## /home      8 GB
### SWAP
##       RAM                  Swap Space
## 2 GB up to 16 GB    Equal to the size of RAM
## Greater than 16 GB       16 GB of SWAP
### BINARIOS ORACLE
## /u01      50 GB
## Oracle Database Volume 1 (db1)  100 GB
## Oracle Database Volume 2 (db2)  100 GB
## Oracle Redo Log Volume  (redo)   10 GB
## Fast Recovery Area       (fra)  200 GB

## 3. Firewall
## Port      Protocol     Description
## 22         TCP      Secure Shell (SSH)
## 443        TCP      Hypertext Transfer Protocol over SSL/TLS (HTTPS)
## 1528       TCP      Oracle Transparent Network Substrate (TNS) Listener default
## 5500       TCP      EM Express 12c default port

############################################################################