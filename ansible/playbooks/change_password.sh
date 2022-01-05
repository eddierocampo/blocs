#/bin/bash
cd /root/users.txt
for i in $(cat users)
do
echo "Colombia2021*" | passwd --stdin $i
done