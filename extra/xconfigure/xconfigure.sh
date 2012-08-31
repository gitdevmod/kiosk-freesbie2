#!/bin/sh
#
# Copyright (c) 2012 djdomics@gmail.com
#
# See COPYING for licence terms.
#
#
# Xorg configure script
#
#
# PROVIDE: xconfigure
# REQUIRE: etcmfs

. /etc/rc.subr

name="xconfigure"
start_cmd="create_xorgconf"
stop_cmd=":"

create_xorgconf() {

	if [ ! -f /usr/local/bin/Xorg ]; then
	    exit
	fi

	echo "Creating /etc/X11/xorg.conf..."
	# XXX set HOME to /tmp for xorg.conf.new 
	HOME=/tmp
	/usr/local/bin/Xorg -configure > /dev/null 2>&1
	HOME=/
	mv /tmp/xorg.conf.new /etc/X11/xorg.conf
	/usr/bin/perl -pi -e 's#	Driver      \"kbd\"#	Driver      \"kbd\"\n	Option \"XkbLayout\" \"XKB_CHANGE_ME\"#' /etc/X11/xorg.conf
	/usr/bin/perl -pi -e 's#Section \"ServerLayout\"#Section \"ServerLayout\"\n	Option \"AutoAddDevices\" \"false\"#' /etc/X11/xorg.conf

}

load_rc_config $name
run_rc_command "$1"
