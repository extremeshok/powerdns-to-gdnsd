#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/musl/bin:$HOME/bin

#TEMP exit with OK
# echo .. OK
# exit 0

#run the script
echo "Testomg the script"
bash powerdns-to-gdnsd.sh --output /tmp/export
if [ "$?" -eq 0 ] ; then
    echo ".. OK"
else
    echo ".. ERROR"
    exit 1
fi

echo "Checking zonefile generation"
if [ -e "/tmp/export/example.com" ] ; then
	echo ".. OK"	
else
	echo ".. ERROR"
	exit 1
fi

#temp to grab the zonefile
echo "The generated zonefile is displayed below, this allows for manaul review of the generated zonefile"
echo "---BEGIN---"
cat /tmp/export/example.com
echo "---END---"

if [ -e "/tmp/export/addzone.com" ] ; then
	echo "Testing addzone.com"
	cp -f /tmp/export/addzone.com /etc/gdnsd/zones/addzone.com
	myresult="$(gdnsd -c /etc/gdnsd checkconf 2>&1 | grep "fatal")"
	if [ "$myresult" == "" ]; then
		echo ".. OK"	
	else
		echo "$myresult"
		echo ".. ERROR"
		exit 1
	fi
else
	echo "addzone.com not found"
fi
