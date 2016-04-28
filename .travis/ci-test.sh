#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/musl/bin:$HOME/bin

#TEMP exit with OK
# echo .. OK
# exit 0

#run the script
bash powerdns-to-gdnsd.sh --output /tmp/export
if [ "$?" -eq 0 ] ; then
    echo "Success"
else
    echo "Error"
    exit 1
fi

#check zonefile generation
if [ -e "/tmp/export/example.com" ] ; then
	echo .. OK	
else
	echo .. ERROR
	exit 1
fi

#temp to grab the zonefile
cat /tmp/export/example.com

