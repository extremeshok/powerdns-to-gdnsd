#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/musl/bin:$HOME/bin

#save the current dir for later
#ORIG_PWD=$PWD

echo "Creating the PowerDNS Database and User"
mysql --host=localhost --user=root  << EOF
CREATE DATABASE IF NOT EXISTS powerdns character set utf8;
GRANT ALL ON powerdns.* TO 'powerdns'@'%' IDENTIFIED BY '8wksjehkaj';
FLUSH PRIVILEGES;
EOF
if [ "$?" -eq 0 ] ; then
    echo "Success"
else
    echo "Error"
    exit 1
fi

echo "Importing the PowerDNS mysql schema"
mysql --host=localhost --user=root --database=powerdns < ".travis/tests/powerdns/schema.mysql.sql"
if [ "$?" -eq 0 ] ; then
    echo "Success"
else
    echo "Error"
    exit 1
fi

echo "Importing the PowerDNS mysql example.com zone"
mysql --host=localhost --user=root --database=powerdns < ".travis/tests/powerdns/mysql-zones/example.com.sql"
if [ "$?" -eq 0 ] ; then
    echo "Success"
else
    echo "Error"
    exit 1
fi

echo "Testing database is correctly configured"
myresult="$(mysql --user=powerdns --password="8wksjehkaj" --database=powerdns --skip-column-name -e "SELECT name FROM domains WHERE name='example.com' ")"
if [ "$myresult" = "example.com" ] ; then
  echo "Success"
else
  echo "Error"
  exit 1
fi