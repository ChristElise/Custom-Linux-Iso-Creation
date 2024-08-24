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
Here, we can see three files and three folders but the most important for us is the **build.sh** bash script which helps us to build our Kali Linux ISO from scratch and the **kali-config** which contains templates for carious KALI build flavor.

### 2. KALI ISO Customization
This is where our journey begins because in this stage we will start customizing different components in our KALI Linux. To carry out this customization, we first need to understand the folder structure in the **kali-config** folder. Let's discover the content of this interesting folder.
```bash
kali@pentester:~/live-build-config/kali-config$ ls -l
total 64
drwxrwxr-x 9 pentester pentester 4096 Aug 31 7:00 common
drwxrwxr-x 2 pentester pentester 4096 Aug 31 7:00 installer-default
drwxrwxr-x 2 pentester pentester 4096 Aug 31 7:00 installer-everything
drwxrwxr-x 2 pentester pentester 4096 Aug 31 7:00 installer-netinst
drwxrwxr-x 2 pentester pentester 4096 Aug 31 7:00 installer-purple
lrwxrwxrwx 1 pentester pentester   12 Aug 31 7:00 variant-default -> variant-xfce
drwxrwxr-x 5 pentester pentester 4096 Aug 31 7:00 variant-e17
drwxrwxr-x 3 pentester pentester 4096 Aug 31 7:00 variant-everything
drwxrwxr-x 3 pentester pentester 4096 Aug 31 7:00 variant-gnome
drwxrwxr-x 4 pentester pentester 4096 Aug 31 7:00 variant-i3
drwxrwxr-x 3 pentester pentester 4096 Aug 31 7:00 variant-kde
drwxrwxr-x 3 pentester pentester 4096 Aug 31 7:00 variant-large
drwxrwxr-x 3 pentester pentester 4096 Aug 31 7:00 variant-light
drwxrwxr-x 3 pentester pentester 4096 Aug 31 7:00 variant-lxde
drwxrwxr-x 3 pentester pentester 4096 Aug 31 7:00 variant-mate
drwxrwxr-x 2 pentester pentester 4096 Aug 31 7:00 variant-minimal
drwxrwxr-x 4 pentester pentester 4096 Aug 31 7:00 variant-xfce
```
Here we can distinguish three folder naming formats i.e. *variant-xxxx*, *installer-xxxx*, and *common*. Let's break this down.

**common**: This folder contains the files common in all types of Kali Linux images.<br>
**installer-xx**: These folders contain configuration files to build the Kali Linux installer image.<br>
**variant-xx**: These folders contain configuration files to build the Kali Linux live image.<br>
**NB**: *For most of them "xx" represents the desktop environment used when building the ISO (e.g. gnome, xfce, i3, etc), while for others it represents the packages that will be included in the image file.*




















