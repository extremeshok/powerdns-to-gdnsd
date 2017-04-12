#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/local/musl/bin:$HOME/bin

pwd
sh -e .t/tests/test-shell.sh || sh -ex .t/tests/test-shell.sh