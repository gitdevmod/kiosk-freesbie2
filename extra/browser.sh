#!/bin/sh
#
# Copyright (c) 2012 djdomics@gmail.com
#
# See COPYING for licence terms.
#
#

set -e -u

if [ -z "${LOGFILE:-}" ]; then
	echo "This script can't run standalone."
	echo "Please use launch.sh to execute it."
	exit 1
fi

cp extra/browser/browser.sh $BASEDIR/etc/rc.d/browser
chmod 555 $BASEDIR/etc/rc.d/browser
