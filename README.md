# **Custom Kali Linux Image ISO Creation**

This repository explains everything that a beginner hacker needs to know to build a custom Kali Linux ISO image with their desired tools incorporated in the ISO image. Doing so increases efficiency because during every Kali Linux install, all your desired tools will be integrated and there is no need to "apt-get install" anymore for those specific tools. Enjoy the post and have fun. Don't forget to continue hacking.

---

### 1. Setting Up The Environment
To start, we need to set up the building environment by installing and configuring the necessary packages using these commands.

```bash
kali@pentester:~$ sudo apt update
kali@pentester:~$ sudo apt install -y git live-build simple-cdd cdebootstrap curl
```

We now need to download the GitLab repository which contains all the necessary files which we will use to shape our custom Kali Linux ISO to our needs.
```bash
kali@pentester:~$ git clone https://gitlab.com/kalilinux/build-scripts/live-build-config.git
```
After downloading the repository we can then list its contents.
```bash
kali@pentester:~$ cd live-build-config 
kali@pentester:~/live-build-config$ ls
auto  build_all.sh  build.sh  kali-config  README.md  simple-cdd
```
Here, we can see three files and three folders but the most important for us is the **build.sh** bash script used to build our Kali Linux ISO from scratch and the **kali-config** which contains templates for carious Kali build flavour.

### 2. Understanding the Directory Structure of the Repository

This is where our journey begins because in this stage we will understand the different options we have to customise our custom Kali Linux image. To carry out this customisation, we first need to understand the folder structure in the **kali-config** folder. Let's discover the content of this interesting folder.
```bash
kali@pentester:~/live-build-config/kali-config$ ls 
common             installer-everything  installer-purple  variant-e17         variant-gnome  variant-kde    variant-light  variant-mate     variant-xfce
installer-default  installer-netinst     variant-default   variant-everything  variant-i3     variant-large  variant-lxde   variant-minimal
```
Here we can distinguish three folder naming formats i.e. *variant-xxxx*, *installer-xxxx*, and *common*. Let's break this down.

• **common**: This folder contains the files common in all Kali Linux images.<br>
• **installer-xx**: These folders contain configuration files to build the Kali Linux installer image.<br>
• **variant-xx**: These folders contain configuration files to build the Kali Linux live image.

**NB**: *For most of them "xx" represents the desktop environment used when building the ISO (e.g. gnome, xfce, i3, etc), and for others it represents the packages that will be included in the image file (we will talk about these packages below).*

**a)** First let's understand the components of the  **common** directory and how it can help us to customise our Kali Linux image. This directory contains the following folders.
```bash
kali@pentester:~/live-build-config/kali-config/common$ ls
bootloaders  hooks  includes.binary  includes.chroot  includes.installer  package-lists  preseed
```
These folders contain different scripts used in the building process of the Kali Linux image. For this workshop, we will touch the **hooks**, **includes.chroot**, and **includes.installer** folders. These folders have the following functions.<br>

• **hooks**: This folder contains bash script hooks. Bash hook scripts are special scripts that are executed at a predefined point in a process to customise or extend its behavior. Here, they will be executed at specific points during the build process. These hooks allow you to customise and extend the build process according to your requirements.<br>
• **includes.chroot**: This folder represents the overlaying of files in the Linux root directory (/). Custom files we may want to integrate with our Kali Linux image can be placed here.<br>
• **includes.installer**: This folder is used to configure automated installations using preseeding. Preseeding is a method used in Debian-based systems to automate the installation process by pre-configuring the installer with answers to the prompts normally asked during installation.<br>

**b)** Next, depending on which image we want (live or installer), which desktop environment, or which packages we want to be preinstalled we can choose any of the folders having as the naming format **installer-xx** or **variant-xx**. In this workshop, we will choose the **variant-light** because by default it is the lightest installation (*NB: Depending on the additional packages added it can also become the heaviest*). Let's study the directory structure and how it can help us to customise our Kali Linux image. The directory structure here is very simple and it applies to almost all the other folders.
```bash
kali@pentester:~/live-build-config/kali-config$ tree variant-light 
variant-light
└── package-lists
    └── kali.list.chroot
```
As we can see we have a **package-list** folder which contains the **kali.list.chroot** file. This file contains packages that are installed by default in the custom Kali Linux image and can be modified to include any tool that can be installed using ***apt install \<package name\>***.

### 3. Getting Our Hands Dirty :yum:
We have talked a lot of theory now it's time to use our understanding of the **live-build-config** directory structure to create our custom Kali Linux Image. This will be broken down into various steps. *NB: These steps are followed after installing dependencies and cloning the **live-build-config** from GitLab*.

#### Step 1: Make Kali Install on its own
Tired of playing the endless game of "Enter, Yes, Enter, Enter, Yes" every time you install Kali Linux? Or maybe you'd rather kick off the installation and hit the sack, instead of risking a caffeine-fueled disaster by turning your keyboard into a coffee sponge while you mash the Enter key like it's your job? Well, here we will study how to automate your installation process using preseeding scripts for unattended installation that does all the hard work for you.
We will create a Linux image that installs on its own when we select the installation option **Start Installer**. We will perform this using preseeding, preseeding provides a way to set answers to questions asked during the installation process, without having to manually enter the answers while the installation is running. This makes it possible to fully automate most types of installation and even offers some features not available during normal installations. Many custom preseeding script exist out there but for this workshop we will my custom [preseed.cfg file](https://github.com/ChristElise/Custom-Linux-Iso-Creation/blob/main/preseed.cfg). I will not go deeper into how to write preseed scripts but for more information, you can reference this link [Automating the installation using preseeding](https://www.debian.org/releases/bookworm/amd64/apb.en.html). To automate our installation we will have to replace the default preseed script in the **live-build-config/kali-config/common/includes.installer** directory with ours.

```bash
kali@pentester:~/live-build-config$ wget https://raw.githubusercontent.com/ChristElise/Custom-Linux-Iso-Creation/main/preseed.cfg -O kali-config/common/includes.installer/preseed.cfg
```
Don't forget that this is your custom Kali Linux image so, of course, there are some fills in the preseeding script you would like to modify such as language, username, password, etc for this you need to edit some entries in the preseed.cfg script you just downloaded above. Some basic modifications can be done using the commands below.

```bash
kali@pentester:~/live-build-config$ filepath="kali-config/common/includes.installer/preseed.cfg"
kali@pentester:~/live-build-config$ sed -i "s/MY_FULLNAME/John Noah/"  $filepath
kali@pentester:~/live-build-config$ sed -i "s/MY_USERNAME/Jnoah/" $filepath
kali@pentester:~/live-build-config$ sed -i "s/MY_PASSWORD/$(mkpasswd -m sha-512 Str0ngP@ssword)/" $filepath
```

#### Step 2: Enhancing Kali Linux ISO with Custom Scripts
Integrating custom scripts into your Kali Linux ISO is an excellent strategy to streamline your workflow. By embedding these scripts directly into the ISO, they become readily available immediately after installation, eliminating the need to download or configure them each time you set up Kali. This approach saves time and ensures that your environment is consistently tailored to your specific needs right from the start. These scripts or any other file can be added to the **live-build-config/kali-config/common/includes.chroot** directory. Let's store the Firefox password extractor script in this directory and change the custom Kali wallpaper.

```bash
kali@pentester:~/live-build-config$ mkdir kali-config/common/includes.chroot/opt
kali@pentester:~/live-build-config$ wget https://raw.githubusercontent.com/unode/firefox_decrypt/main/firefox_decrypt.py -O kali-config/common/includes.chroot/opt/firefox_decrypt.py

kali@pentester:~/live-build-config$  # Replacing Kali default wallpaper
kali@pentester:~/live-build-config$ mkdir -p kali-config/common/includes.chroot/usr/share/wallpapers/kali/contents/images
kali@pentester:~/live-build-config$ wget https://www.example.com/sample-image.png
kali@pentester:~/live-build-config$ mv sample-image.png kali-config/common/includes.chroot/usr/share/wallpapers/kali/contents/images/wp-blue.png
```

#### Step 3: Customizing Kali Build Process with Bash Scripts
We can now create hook scripts that will run at various stages of the build. Here we will create a hook script that will install additional python3 packages during the creation of the Kali Linux ISO file. For more information about hooks and how they can be used check this link [Hooks](https://live-team.pages.debian.net/live-manual/html/live-manual/customizing-contents.en.html#507).

```bash
kali@pentester:~/live-build-config$ echo '#!/bin/bash' > kali-config/common/hooks/live/99-install-python-packages.hook.chroot 
kali@pentester:~/live-build-config$ echo "pip3 install uploadserver" >> kali-config/common/hooks/live/99-install-python-packages.hook.chroot 
kali@pentester:~/live-build-config$ chmod 755 kali-config/common/hooks/live/99-install-python-packages.hook.chroot 
```
#### Step 4: Customizing Installed Packages
We are almost done with the process. What's is remaining is to edit the **kali.list.chroot** in any of the available variants and add all the packages (such as Nmap, Metasploit, Crackmapexec, etc ) we want in our default custom installation. Thanks to Kali's structure we will not have to write every package one by one since Kali Linux offers us metapackages which are combinations of different packages. A list of all available metapackages and their component can be found here [kali-meta](https://www.kali.org/tools/kali-meta/).

```bash
kali@pentester:~/live-build-config$ echo "kali-linux-default\nkali-tools-top10\npowershell\npython3\npython3-pip" >>   kali-config/variant-light/package-lists/kali.list.chroot
```

#### Step 4: Building our Kali ISO Image
After customizing our desired build to fit our taste we can now run the **build.sh** script found in the **live-build-config** directory providing arguments for it to build an ISO image for the Kali built we have customised in our case **kali-config/variant-light**.

```bash
kali@pentester:~/live-build-config$ ./build.sh --variant light --verbose --arch amd64  --distribution kali-rolling

RUNNING: lb clean --purge
[2024-08-24 04:59:11] lb clean --purge
P: Executing auto/clean script.

<SNIP>

P: Build completed successfully
RUNNING: mv -f live-image-amd64.hybrid.iso ./images/kali-linux-rolling-live-light-amd64.iso
RUNNING: mv -f /home/whitemiller/live-build-config/build.log ./images/kali-linux-rolling-live-light-amd64.log
RUNNING: echo -e '\n***\nGENERATED KALI IMAGE: ./images/kali-linux-rolling-live-light-amd64.iso\n***'

***
GENERATED KALI IMAGE: ./images/kali-linux-rolling-live-light-amd64.iso
***
            
kali@pentester:~/live-build-config$ ls images           
kali-linux-rolling-live-light-amd64.log   kali-linux-rolling-live-light-amd64.iso
```
#### Step 5: Install Your Custom Kali 
A script to automate all this process can be accessed using the link [Build Custom Kali](https://github.com/ChristElise/Custom-Linux-Iso-Creation/blob/main/build_custom_kali.sh), feel free to modify the script so that it can fit your needs. The final step is to install your custom Kali Linux image. By selecting the Start Installer option, Kali Linux will be installed using the prebuilt preseed script, which requires no user interaction. Alternatively, you also have the option to start it as a live system.
![Installation Screen](https://raw.githubusercontent.com/ChristElise/Custom-Linux-Iso-Creation/main/images/Installation%20Screen.png)

Great news! You can now test your custom Kali Linux installation by tackling challenges on HackTheBox or TryHackMe.

Thank you for taking the time to read this post!


