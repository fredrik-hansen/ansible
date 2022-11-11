# Setup Headless Virtualization Server Using KVM
sudo apt-get install qemu-kvm libvirt-bin virtinst bridge-utils cpu-checker
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
sudo virsh list --all
#To install an ISO
#sudo virt-install --name ossim2 --ram=32768 --vcpus=4 --cpu host --hvm --disk path=/var/lib/libvirt/images/ossim-vm2,size=128 --cdrom /var/lib/libvirt/boot/AlienVault_OSSIM_64bits.iso --graphics vnc

#To start a VM, run:

#$ sudo virsh start Ubuntu-16.04
#To restart a VM, run:

#$ sudo virsh reboot Ubuntu-16.04
#To pause a running VM, run:

#$ sudo virsh suspend Ubuntu-16.04
#To shutdown a VM, run:

#$ sudo virsh shutdown Ubuntu-16.04
#To completely remove a VM, run:

#$ sudo virsh undefine Ubuntu-16.04
#$ sudo virsh destroy Ubuntu-16.04


