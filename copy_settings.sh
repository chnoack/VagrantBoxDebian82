#!/bin/bash

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
