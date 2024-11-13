sudo lvextend --extents +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv



#
#Get rid of snap version of firefox
#
sudo snap remove firefox
sudo add-apt-repository ppa:mozillateam/ppa
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
sudo apt install firefox

#
#Add to end of rsyslog.conf
#
$template remote-incoming-logs, "/var/log/hosts/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?remote-incoming-logs
& ~



# Fix crackling sound
mkdir ~/.config/pipewire
cp /usr/share/pipewire/*.conf ~/.config/pipewire
chown $USER ~/.config/pipewire/pipewire-pulse.conf
Edit the pulse-properties.conf file

nano ~/.config/pipewire/pipewire-pulse.conf

Find the pulse properties section, uncomment the following keys, and set their values to either 512 or 1024

pulse.min.req = 1024/48000

pulse.min.frag = 1024/48000

pulse.min.quantum = 1024/48000 
systemctl --user restart pipewire.service
