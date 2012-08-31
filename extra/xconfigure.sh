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

mkdir -p $BASEDIR/etc/X11/ $BASEDIR/etc/rc.d/

cp extra/xconfigure/xconfigure.sh $BASEDIR/etc/rc.d/xconfigure
chmod 555 $BASEDIR/etc/rc.d/xconfigure
