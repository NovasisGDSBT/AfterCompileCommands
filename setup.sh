#!/bin/sh
USER=`whoami`
if [ "$USER" = "root" ]; then
        echo "root not allowed to start this script, giving up"
        exit
fi
if [ "${1}" = "" ]; then
        echo "This script must be started by buildroot, giving up"
        exit
fi
TARGET_DIR=${1}
HERE=`dirname $0`

#Leave some space
dd if=/dev/zero of=${HERE}/Init/bin/Space bs=16M count=1

# Check if this is a chromium build
echo ${TARGET_DIR} | grep "Chrome"
if [ "${?}" == "0" ]; then
        echo "**** C H R O M I U M    B R O W S E R ****"
        DIRS="Init ChromiumBrowser"
else
        echo "****  S T A N D A R D    F I L E   S Y S T E M ****"
        DIRS="Init XWindows Wireless"
fi

# Copy customized files
for i in ${DIRS} ; do
        echo -n "Setting ${i} ... "
        cp -rd ${HERE}/${i}/* ${TARGET_DIR}/.
        echo "Done"
done
if [ -f ${TARGET_DIR}/usr/sbin/chrome_sandbox ]; then
        chmod 7455 ${TARGET_DIR}/usr/sbin/chrome_sandbox
fi
rm -f `find ${TARGET_DIR} -name .*swp`

#Remove ssh and ssl keys
#[ -d ${TARGET_DIR}/etc/ssh ] && rm -rf ${TARGET_DIR}/etc/ssh
#[ -d ${TARGET_DIR}/etc/ssl ] && rm -rf ${TARGET_DIR}/etc/ssl
[ -d ${TARGET_DIR}/etc/default_init ] && rm -rf ${TARGET_DIR}/etc/default_init

LOCALEDIR="${TARGET_DIR}/usr/share/locale"
rm -rf ${LOCALEDIR}/a* ${LOCALEDIR}/b* ${LOCALEDIR}/c* ${LOCALEDIR}/da ${LOCALEDIR}/dz ${LOCALEDIR}/f* ${LOCALEDIR}/g* ${LOCALEDIR}/h* ${LOCALEDIR}/j* ${LOCALEDIR}/k* ${LOCALEDIR}/l* ${LOCALEDIR}/m* ${LOCALEDIR}/n* ${LOCALEDIR}/o* ${LOCALEDIR}/p* ${LOCALEDIR}/r* ${LOCALEDIR}/s* ${LOCALEDIR}/t* ${LOCALEDIR}/u* ${LOCALEDIR}/v* ${LOCALEDIR}/w* ${LOCALEDIR}/x* ${LOCALEDIR}/y* ${LOCALEDIR}/z*
