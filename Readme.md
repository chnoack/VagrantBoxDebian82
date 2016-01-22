# Vagrant Virtual Box Machine for Ubuntu 14.04/Desktop

This is just a Vagrant setup for a Ubuntu VirtuaBox for developers. The VM contains:

* Ubuntu Trusty 14.04
* Mate-Desktop
* postgresql
* atom
* git
* jdk8
* rvm with ruby 2.2.x installed
* chrome browser
* docker + docker-compose
* node.js + npm

## Prerequisist

* Virtual Box: https://www.virtualbox.org  (may work with VMWare also)
* Install Vagrant: https://www.vagrantup.com/downloads.html
* Install Vagrant Proxy Conf: https://github.com/tmatilai/vagrant-proxyconf
* start VirtualBox and configure the path you want your virtual boxes to be stored
* add path of `VirtualBoxManage` to your system's PATH environment variable
* the path of the folder where your VirtualBox installation stores the virtual machine disks in should not contain any spaces or special characters

## Adjust to your needs

### Proxy setup

If you're virtual machine is behind a proxy, you can configure the proxy within the Vagrantfile (Vagrant Proxy Conf needed, see above). In your virtual machine the proxy configuration will then be set automatically for:
* Apt
* Docker
* Git
* npm
* atom


### Virtual Disks

The base configuration of the virtual machine contains one disk of 40 GB. The Vagrantfile contains the definition of an additional disk of 20 GB with is mounted to /var/lib/docker. You can change it's size in the `Vagrantfile` if you like. This disk is for your docker development. It's the place where docker stores all images and containers in. A separate disk makes sense, because when working with docker a lot of space is needed in /var/lib/docker and you do not want your system partition to run out of free disk space.



You may add another disk to your vm if you like.


### Port forwarding

The Vagrant file contains a setup for forwarding some ports you might need during development of ruby or java applications. Modify them if you like.


### Mounted folders

The following folders are mounted into the VM:

* local folder where Vagrantfile is in -> /vagrant

Add additional folders to the `Vagrantfile` if you like.


### SSH keys

If you need special ssh keys you already have, just place them into the folder `customize/ssh-keys`. This allows you to ssh to  machines without entering login/password. Be aware `authorized_keys` will not be copied, but instead automatically removed from the folder.

### Additional software / system modification

 If you want to change the setup of the VM or you need extra software you may modify `bootstrap.sh`. Afterwards you have to do `vagrant provision`.  Do this only, if you absolutely know what this is all about.

## Running

After you have adjust the machines configuration you can start it as follows (form the directory `Vagrantfile` resides):

`vagrant up`

If you do this the fist time, it may take several minutes, because all artifacts will be loaded from the internet. Be patient and wait until the setup is complete. The stop the virtual machine:

`vagrant stop`

Now you can run it everytime with:

`vagrant up`

If you start the virtual machine from the VirtualBox Manager, you cannot change the proxy settings and you shoud enable "automount" for all attached disks before. Otherwise you won't have them inside your machine.

## login

Autologin is activated. The user is `vagrant` and the password is `vagrant`. This is a sudo-user who is allowed to do all (wit h `sudo`).

# License & Warranty

This is just my personal setup. It comes without any warranty. The contained and referenced software artifacts have all their own licenses. I tried to setup  this machine with open source software or freeware only, but I am no responsible for the right use of software & licenses in your enivironment.
