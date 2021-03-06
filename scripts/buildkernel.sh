#!/bin/sh
#
# pfSense specific buildkernel.sh
#
# Copyright (c) 2009 Scott Ullrich
# Copyright (c) 2005 Dario Freni
#
# See COPYING for licence terms. (hint: BSD License)
#

set -e -u

if [ -z "${LOGFILE:-}" ]; then
    echo "This script can't run standalone."
    echo "Please use launch.sh to execute it."
    sleep 999
    exit 1
fi

if [ -n "${NO_BUILDKERNEL:-}" ]; then
    echo "+++ NO_BUILDKERNEL set, skipping build" | tee -a ${LOGFILE}
    return
fi

# Set SRC_CONF variable if it's not already set.
if [ -z "${SRC_CONF:-}" ]; then
    if [ -n "${MINIMAL:-}" ]; then
		SRC_CONF=${LOCALDIR}/conf/make.conf.minimal
    else
		SRC_CONF=${LOCALDIR}/conf/make.conf.${FREEBSD_VERSION}
    fi
fi

if [ -n "${KERNELCONF:-}" ]; then
    KERNCONFDIR=$(dirname ${KERNELCONF})
    KERNCONF=$(basename ${KERNELCONF})
elif [ -z "${KERNCONF:-}" ]; then
    KERNCONFDIR=${LOCALDIR}/conf/${ARCH}
    KERNCONF="FREESBIE"
fi

if [ -z "${WITH_DTRACE:-}" ]; then
	DTRACE=""
else
	DTRACE=" WITH_CTF=1"
fi

echo ">>> KERNCONFDIR: ${KERNCONFDIR}"
echo ">>> ARCH:        ${ARCH}"
echo ">>> SRC_CONF:    ${SRC_CONF}"
if [ "$DTRACE" != "" ]; then
	echo ">>> DTRACE:     ${DTRACE}"
fi

# Set __MAKE_CONF variable if it's not already set.
if [ -z "${MAKE_CONF:-}" ]; then
        MAKE_CONF=""
else
        echo ">>> MAKE_CONF:    $MAKE_CONF"
        MAKE_CONF="__MAKE_CONF=$MAKE_CONF"
fi

unset EXTRA

makeargs="${MAKEOPT:-} SRCCONF=${SRC_CONF} ${MAKE_CONF} TARGET=${ARCH} TARGET_ARCH=${ARCH} ${DTRACE} KERNCONFDIR=${KERNCONFDIR} KERNCONF=${KERNCONF} ${MAKEJ_KERNEL:-}"

if [ "$ARCH" = "MIPS" ]; then
	echo ">>> FreeSBIe2 is running the command: env $MAKE_ENV script -aq $LOGFILE make ${makeargs:-} kernel-toolchain" > /tmp/freesbie_buildworld_cmd.txt
	echo ">>> MIPS ARCH deteceted, running make kernel-toolchain ..."
	(env $MAKE_ENV script -aq $LOGFILE make $makeargs kernel-toolchain ${MAKEJ_KERNEL:-} || print_error;) | egrep '^>>>'
fi

echo ">>> FreeSBIe2 is running the command: env $MAKE_ENV script -aq $LOGFILE make $makeargs buildkernel" \
	> /tmp/freesbie_buildkernel_cmd.txt

cd $SRCDIR

# If -j is defined sometimes a kernel build
# will fail.  Attempt to try again up to 9
# more times and fail out completely if we
# cannot get this right in 10 attempts.
if [ "${MAKEJ_KERNEL:-}" != "" ]; then
	COUNTER=1
else
	COUNTER=9
fi
while [ "$COUNTER" -lt 10 ]; do
	(env $MAKE_ENV script -aq $LOGFILE make $makeargs buildkernel || print_error;) | egrep '^>>>'
	if [ "$?" -gt 0 ]; then
		if [ "$COUNTER" -gt 9 ]; then
			exit 1
		fi
		echo ">>> make -j error occured attempt #$COUNTER - retrying build up to 10 times"
	else 
		COUNTER=11
	fi
	COUNTER=`expr $COUNTER + 1`
done

cd $LOCALDIR
