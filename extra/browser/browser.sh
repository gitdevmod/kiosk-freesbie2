#!/bin/sh
#
# Copyright (c) 2012 djdomics@gmail.com
#
# See COPYING for licence terms.
#
#
# PROVIDE: browser
# REQUIRE: etcmfs

. /etc/rc.subr

name="browser"
start_cmd="browser_start"
stop_cmd=":"

browser_start () { 
	HOMEPAGE=`kenv -q freesbie.homepage`
	MOZ_CFG=/usr/local/etc/firefox/mozilla.cfg
	echo "lockPref(\"browser.startup.homepage\",\"${HOMEPAGE}\");" >> ${MOZ_CFG}
}

load_rc_config $name
run_rc_command "$1"
