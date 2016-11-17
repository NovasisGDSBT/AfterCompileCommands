. /etc/sysconfig/system_vars
. /etc/sysconfig/network

[ -d /usr/lib/node_modules ] && ln -s /usr/lib/node_modules
[ -f /bin/Space ] && rm -f /bin/Space
[ -f /root/chpasswd_novasis ] && /root/chpasswd_novasis >/dev/null 2>&1

if [ -d /tmp/application_storage ]; then
	if [ -f /tmp/application_storage/AutoRun.sh ]; then
		chmod 777 /tmp/application_storage/AutoRun.sh
		/tmp/application_storage/AutoRun.sh &
	fi
fi
echo "REFERENCE_SERVER set as ${REFERENCE_SERVER}"
