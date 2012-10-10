#!/bin/sh
#
# Copyright (c) 2012 djdomics@gmail.com
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
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

	# set keyboard layout
	/usr/bin/perl -pi -e 's#	Driver      \"kbd\"#	Driver      \"kbd\"\n	Option \"XkbLayout\" \"XKB_CHANGE_ME\"#' /etc/X11/xorg.conf
	/usr/bin/perl -pi -e 's#Section \"ServerLayout\"#Section \"ServerLayout\"\n	Option \"AutoAddDevices\" \"false\"#' /etc/X11/xorg.conf

	# set blank time
	kenvblanktime=`kenv -q kiosk.blanktime`
	blanktime=${kenvblanktime:-"10"}

	if [ $blanktime -eq 0 ] ; then
		/usr/bin/perl -pi -e "s#Section \"Monitor\"#Section \"Monitor\"\n	Option "\"DPMS" "\"false\""#" /etc/X11/xorg.conf
	else
		/usr/bin/perl -pi -e "s#Section \"Monitor\"#Section \"Monitor\"\n	Option "\"DPMS\"" "\"true\""#" /etc/X11/xorg.conf
		/usr/bin/perl -pi -e "s#Section \"ServerLayout\"#Section \"ServerLayout\"\n	Option "\"BlankTime\""  "\"$blanktime\""#" /etc/X11/xorg.conf
		/usr/bin/perl -pi -e "s#Section \"ServerLayout\"#Section \"ServerLayout\"\n	Option "\"StandbyTime\""  "\"$blanktime\""#" /etc/X11/xorg.conf
		/usr/bin/perl -pi -e "s#Section \"ServerLayout\"#Section \"ServerLayout\"\n	Option "\"SuspendTime\""  "\"$blanktime\""#" /etc/X11/xorg.conf
		/usr/bin/perl -pi -e "s#Section \"ServerLayout\"#Section \"ServerLayout\"\n	Option "\"OffTime\""  "\"$blanktime\""#" /etc/X11/xorg.conf
	fi

}

load_rc_config $name
run_rc_command "$1"
