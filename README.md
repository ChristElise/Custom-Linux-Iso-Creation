# **Custom-Linux-Iso-Creation**

This repository explains everything that a beginner hacker needs to know to build a custom Kali Linux ISO with his/her desired tools incorporated in the ISO file. Doing so increases efficiency because during every Kali Linux install all your desired tools will be integrated and there is no need to "apt-get install " anymore. Enjoy the post and have fun and don't forget to continue hacking

---

### 1. Setting Up The Environment
To start, we need to set up the Kali ISO build environment by installing and configuring the necessary packages using these commands.

```bash
kali@pentester:~$ sudo apt update
kali@pentester:~$ sudo apt install -y git live-build simple-cdd cdebootstrap curl
```

We now need to download the GitLab repository which contains all the necessary files which we will use to shape our custom Kali Linux ISO to our needs.
```bash
kali@pentester:~$ git clone https://gitlab.com/kalilinux/build-scripts/live-build-config.git
```
After downloading the repository we can then move into it and list its contents
```bash
kali@pentester:~$ cd live-build-config 
kali@pentester:~/live-build-config$ ls
auto  build_all.sh  build.sh  kali-config  README.md  simple-cdd
```
Here, we can see three files and three folders but the most important for us is the **build.sh** bash script used to build our Kali Linux ISO from scratch and the **kali-config** which contains templates for carious KALI build flavor.

### 2. Understanding the Directory Structure of the Repository

This is where our journey begins because in this stage we will start customizing different components in our KALI Linux. To carry out this customization, we first need to understand the folder structure in the **kali-config** folder. Let's discover the content of this interesting folder.
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

**a)** First let's understand the components of the  **common** directory and how it can help us to customize our Kali Linux image. This directory contains the following folders.
```bash
kali@pentester:~/live-build-config/kali-config/common$ ls
bootloaders  hooks  includes.binary  includes.chroot  includes.installer  package-lists  preseed
```
These folders contain different scripts used in the building process of the Kali Linux image. For this workshop, we will touch the **hooks**, **includes.chroot**, and **includes.installer** folders. These folders have the following functions.<br>
• **hooks**: This folder contains bash script hooks. Bash hook scripts are special scripts that are executed at a predefined point in a process to customize or extend its behavior. Here the will be executed at specific points during the build process. These hooks allow you to customize and extend the build process according to your requirements.<br>
• **includes.chroot**: This folder represents the overlaying of files in the Linux root directory (/). Custom files we may want to integrate with our Kali Linux ISO can be placed here.<br>
• **includes.installer**: This folder is used to configure automated installations using preseeding. Preseeding is a method used in Debian-based systems (including Kali Linux) to automate the installation process by pre-configuring the installer with answers to the prompts normally asked during installation.<br>

**b)** Next, depending on which image we want (live or installer), which desktop environment, or which packages we want preinstalled we can choose any of the folders having as the naming format **installer-xx** and **variant-xx**. In this workshop, we will choose the **variant-light** because by default it is the lightest installation (*NB: Depending on the additional packages I add it can also become the heaviest*). Let's study the directory structure and how it can help us to customize our Kali Linux image. The directory structure here is very simple and it applies to almost all the other folders.
```bash
kali@pentester:~/live-build-config/kali-config$ tree variant-light 
variant-light
└── package-lists
    └── kali.list.chroot
```
As we can see we have a **package-list** folder which contains the **kali.list.chroot** file. This file contains packages that are installed by default in the Kali Linux ISO and can be modified to include any tool that can be installed with ***apt install \<package name\>***

### 3. Getting Our Hands Dirty
We have talked a lot of theory now it's time to use our understanding to create our custom Kali Linux Image which will be ready to use out of the box for the intended purpose. :wave





























