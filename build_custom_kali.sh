#!/bin/bash

######### Update system and Install dependencies #########
sudo apt update
sudo apt install -y git live-build simple-cdd cdebootstrap curl
sudo apt install -y mkpasswd

######### Download kali live build repository ############
git clone https://gitlab.com/kalilinux/build-scripts/live-build-config.git
cd live-build-config/ 

######### Customise the unattended download option #########
wget https://raw.githubusercontent.com/ChristElise/Custom-Linux-Iso-Creation/main/preseed.cfg -O kali-config/common/includes.installer/preseed.cfg
filepath="./kali-config/common/includes.installer/preseed.cfg"
echo -n "Enter your fullname: "; read fullname
echo -n "Enter your username: "; read username
echo -n "Enter your password: "; read password
sed -i "s/MY_FULLNAME/$fullname/"  $filepath
sed -i "s/MY_USERNAME/$username/"  $filepath
sed -i "s/MY_PASSWORD/$(mkpasswd -m sha-512 $password)/" $filepath

######### Add custom scripts #########
mkdir kali-config/common/includes.chroot/opt
wget https://raw.githubusercontent.com/unode/firefox_decrypt/main/firefox_decrypt.py -O kali-config/common/includes.chroot/opt/firefox_decrypt.py

######### Install extra Python libraries #########
cat <<EOF > kali-config/common/hooks/live/99-install-python-packages.hook.chroot 
#!/bin/bash
pip3 install uploadserver
EOF
chmod 755 kali-config/common/hooks/live/99-install-python-packages.hook.chroot 

######### Customise default tools #########
cat <<EOF >> kali-config/variant-light/package-lists/kali.list.chroot
metasploit-framework
python3-pip
python3
ffuf
EOF

######### Run building process #########
./build.sh --variant light --verbose --arch amd64  --distribution kali-rolling
