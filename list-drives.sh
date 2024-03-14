sudo fdisk -l|grep 'Disk model'
df -h
sudo dmsetup ls --target crypt
sudo lsblk --fs
cat /proc/mdstat 
for i in $(sudo dmsetup targets | cut -f1 -d' '); do echo $i:; sudo dmsetup ls --target $i; echo; done

