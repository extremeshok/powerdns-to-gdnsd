#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/musl/bin:$HOME/bin

mkdir -p /etc/clamav-unofficial-sigs/
cp -f config/master.conf /etc/clamav-unofficial-sigs/master.conf
cp -f confg/os.ubuntu.conf /etc/clamav-unofficial-sigs/os.conf
cp -f .t/tests/user.conf /etc/clamav-unofficial-sigs/user.conf
	

