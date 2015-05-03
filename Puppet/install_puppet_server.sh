#!/bin/bash

clear

yum install puppet puppet-server facter -y

cd /etc/puppet/
puppet master --genconfig > puppet.conf



