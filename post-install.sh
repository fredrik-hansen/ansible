sudo lvextend --extents +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv



#
#Get rid of snap version of firefox
#
sudo snap remove firefox
sudo add-apt-repository ppa:mozillateam/ppa
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
sudo apt install firefox

