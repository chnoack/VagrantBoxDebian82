#!/bin/bash


echo 'setxkbmap -layout de ' >> ~vagrant/.profile # set german keyboard layout for PC
echo 'setxkbmap -layout de ' >> ~vagrant/.bashrc # set german keyboard layout for  PC
#echo 'setxkbmap -layout de -variant mac' >> ~vagrant/.profile # set german keyboard layout for mac
#echo 'setxkbmap -layout de  -variant mac' >> ~vagrant/.bashrc # set german keyboard layout for mac

# allow sudo for user vagrant
echo 'vagrant    ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
usermod -G admin vagrant
groupadd vboxfs
usermod -a -G vboxfs vagrant

# update guest additions do 5.0.12
cd /tmp
wget http://download.virtualbox.org/virtualbox/5.0.12/VBoxGuestAdditions_5.0.12.iso
apt-get remove virtualbox-guest-x11 virtualbox-guest-utils unity-scope-virtualbox
 ./VBoxLinuxAdditions.run --  --force


# make partition for docker if it does not already exist
docker_disk_is_formatted=`blkid /dev/sdb1`
if [ -z "$docker_disk_is_formatted" ]; then
 # make partition
  cat <<EOF | fdisk /dev/sdb
n
p
1


w
EOF

  # format partition
  mkfs.ext4 /dev/sdb1
  # automount partition on boot
  mkdir -p /var/lib/docker
  echo '/dev/sdb1    /var/lib/docker    ext4    defaults            1     2' >> /etc/fstab
fi

mount -a

# install software

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list

add-apt-repository ppa:webupd8team/java
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
add-apt-repository ppa:webupd8team/atom

apt-get update

apt-get install -y wget apt-cacher-ng build-essential libsdl1.2debian python-software-properties debconf-utils git-core zlib1g-dev postgresql libpq-dev zip sqlite3 libsqlite3-dev pgadmin3
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
apt-get install --yes --force-yes -f oracle-java8-installer
apt-get install -y google-chrome-stable nodejs npm
apt-get install --yes --force-yes -f docker-engine
apt-get install --yes --force-yes -f atom

sudo apt-get install -y --no-install-recommends mate-desktop-environment

curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# remove ubuntu cloud services
echo 'datasource_list: [ None ]' | sudo -s tee /etc/cloud/cloud.cfg.d/90_dpkg.cfg
dpkg-reconfigure -f noninteractive cloud-init
apt-get remove --purge cloud-init
rm -rf /var/lib/cloud-init
rm -rf /etc/cloud

# install rvm + ruby
curl -L https://get.rvm.io > /tmp/rvm-install.sh
su - vagrant -c  'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'
sudo -u vagrant -H sh -c 'bash /tmp/rvm-install.sh'
su - vagrant -c 'rvm install 2.2.2'
echo 'export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting' >> ~vagrant/.bashrc
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*' >> ~vagrant/.bashrc
rm /tmp/rvm-install.sh


# enable autologin for user vagrant
echo '[SeatDefaults]' > /etc/lightdm/lightdm.conf
echo 'autologin-user=vagrant' >> /etc/lightdm/lightdm.conf

if [ -d "/vagrant/customization/" ]; then
  # install exsiting ssh keys
  if [ -d "/vagrant/customization/ssh-keys" ]; then
    rm -f /vagrant/customization/authorized_keys # do not copy authorized_keys
    cp /vagrant/customization/ssh-keys/* ~vagrant/.ssh/
    chown vagrant ~vagrant/.ssh/*
    chmod 600 ~vagrant/.ssh/*
    chmod 644 ~vagrant/.ssh/*.pub
    chmod 644 ~vagrant/.ssh/known_hosts
    chmod 755 chmod 644 ~vagrant/.ssh
  fi

  if [ -f "/vagrant/customization/bash_aliases" ]; then
  	cp /vagrant/customization/bash_aliases ~vagrant/.bash_aliases
  fi
fi


# set proxy for atom
if [ -n "$http_proxy" ]; then
  mkdir -p ~vagrant/.atom
  cat << EOF > ~vagrant/.atom/.apmrc
; settings for proxy
https-proxy = ${https_proxy}
http-proxy = ${http_proxy}
EOF
fi
chown -R vagrant ~vagrant
usermod -a -G docker vagrant
