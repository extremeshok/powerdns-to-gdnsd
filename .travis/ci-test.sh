#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/musl/bin:$HOME/bin

pwd

if bash powerdns-to-gdnsd.sh ; then
	echo .. OK
else
 	echo .. ERROR
  exit 1
fi

#check cron file generation
if [ -e "/export/sampledomain.com" ] ; then
	echo .. OK	
else
	echo .. ERROR
	exit 1
fi
