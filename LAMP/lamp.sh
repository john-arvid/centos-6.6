#!/bin/bash

yum install httpd php -y

service httpd start

chkconfig httpd on
