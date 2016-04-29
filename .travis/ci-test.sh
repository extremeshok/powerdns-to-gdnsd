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

echo "Checking example.com zonefile generation"
if [ -e "/tmp/export/example.com" ] ; then
	echo ".. OK"	
	echo "The generated example.com zonefile is displayed below, this allows for manaul review of the generated zonefile"
	echo "---BEGIN---"
	cat /tmp/export/example.com
	echo "---END---"
else
	echo ".. ERROR"
	exit 1
fi

echo "Checking addzone.com zonefile generation"
if [ -e "/tmp/export/addzone.com" ] ; then
	echo ".. OK"
	echo "The generated addzone.com zonefile is displayed below, this allows for manaul review of the generated zonefile"
	echo "---BEGIN---"
	cat /tmp/export/addzone.com
	echo "---END---"
else
	echo ".. ERROR"
	exit 1
fi

## gdsnd is not functioning on travis platform, we will have to source compile it to do testing.
# echo "Testing zonefiles with gdnsd"
# mkdir -p /etc/gdnsd/zones
# cp -f /tmp/export/addzone.com /etc/gdnsd/zones/addzone.com

# echo "$(gdnsd -c /etc/gdnsd checkconf 2>1)"
##we wont fail this yes, more this is done to grab the input to work out the next steps

# myresult="$(gdnsd -c /etc/gdnsd checkconf 2>&1 | grep "fatal")"
# if [ "$myresult" == "" ]; then
# 	echo ".. OK"	
# else
# 	echo "$myresult"
# 	echo ".. ERROR"
# 	exit 1
# fi