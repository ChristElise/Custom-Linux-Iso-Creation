#!/bin/bash

### Update system and Install dependencies ###
sudo apt update
sudo apt install -y git live-build simple-cdd cdebootstrap curl

### Download kali live build repository ###
git clone https://gitlab.com/kalilinux/build-scripts/live-build-config.git
cd live-build-config/

#### Add a customised syslinux boot entry which includes a boot parameter for a custom preseed file ###
cat <<EOF > kali-config/common/includes.binary/isolinux/install.cfg
label install
    menu label ^Install Automated
    linux /install/vmlinuz
    initrd /install/initrd.gz
    append vga=788 -- quiet file=/cdrom/install/preseed.cfg locale=en_US keymap=us hostname=kali domain=local.lan
EOF
# Making it executable
chmod 755 kali-config/common/includes.binary/isolinux/install.cfg

#### Customize the unattended download option ####
filepath="./kali-config/common/includes.installer/preseed.cfg"
wget https://gitlab.com/kalilinux/recipes/kali-preseed-examples/-/raw/master/kali-linux-full-unattended.preseed -O $filepath
# Changing Location, Language, Country, and Timezone respectively
sed -i  '3s/en_US/en_GB/' $filepath
sed -i  '3a\d-i debian-installer\/language string en' $filepath
sed -i  '6s/enter information manually/GB/' $filepath
sed -i  '13s/US\/Eastern/Europe\/London/' $filepath 
#Changing Host information
sed -i  '42s/unassigned-hostname/kali.local/' $filepath
sed -i  '45s/false/true/' $filepath
sed -i  '45a\d-i passwd\/user-fullname string pentester' $filepath
sed -i  '46a\d-i passwd\/username string pentester' $filepath
sed -i  "47a\d-i passwd\/user-password-crypted password $(mkpasswd -m sha-512 pentester)" $filepath
sed -i  '48a\d-i passwd\/root-login boolean false' $filepath
sed -i  's/d-i passwd\/root-password password toor/#d-i passwd\/root-password password toor/' $filepath
sed -i  's/d-i passwd\/root-password-again password toor/#d-i passwd\/root-password-again password toor/' $filepath

### Add custom scripts ###
mkdir kali-config/common/includes.chroot/opt
#--cd path/to/custom/script  kali-config/common/includes.chroot/opt
 

### Install extra Python libraries ###
cat <<EOF > kali-config/common/hooks/live/99-install-python-packages.hook.chroot 
#!/bin/bash

pip3 install uploadserver
pip3 install <package name>

EOF

chmod 755 kali-config/common/hooks/live/99-install-python-packages.hook.chroot 

### Customize default tools ###
cat <<EOF >> kali-config/variant-light/package-lists/kali.list.chroot
metasploit-framework

EOF


### Run building process ###
./build.sh --variant light --verbose --arch amd64  --distribution kali-rolling
