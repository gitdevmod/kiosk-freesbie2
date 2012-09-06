#!/bin/sh
#
# cleanup .mozilla directory
# start firefox with correct height and width resolution
#

while true ; do
	if [ -d ${HOME}/.mozilla ] ; then
		rm -fr ${HOME}/.mozilla
	fi
	
	if [ -r /usr/local/bin/xrandr ] && [ -r /usr/local/bin/firefox ] ; then
		WIDTH=$(xrandr | grep \* | cut -d' ' -f4 | awk -F'x' '{print $1}')
		HEIGHT=$(xrandr | grep \* | cut -d' ' -f4 | awk -F'x' '{print $2}')
		/usr/local/bin/firefox -height ${HEIGHT} -width ${WIDTH}
	else
		exit
	fi
done
