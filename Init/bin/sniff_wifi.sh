#!/bin/sh
while [ ! -f /tmp/my_ip ]; do
	sleep 1
done
wpa_cli terminate >/dev/null 2>&1
sleep 1
/sbin/insmod /lib/modules/brcmutil.ko >/dev/null 2>&1
/sbin/insmod /lib/modules/brcmfmac.ko >/dev/null 2>&1
sleep 1
echo "ctrl_interface=/var/run/wpa_supplicant" > /etc/wpa_supplicant.conf
echo "ap_scan=1" >> /etc/wpa_supplicant.conf
echo "update_config=1" >> /etc/wpa_supplicant.conf
echo "network={" >> /etc/wpa_supplicant.conf
echo "}" >> /etc/wpa_supplicant.conf

/usr/sbin/wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf &
echo "/usr/sbin/wpa_supplicant $?"
sleep 2
/usr/sbin/wpa_cli reconfigure >/dev/null 2>&1
echo "/usr/sbin/wpa_cli reconfigure $?"
sleep 1
/usr/sbin/wpa_cli scan >/dev/null 2>&1
echo "/usr/sbin/wpa_cli scan $?"
sleep 1
/usr/sbin/wpa_cli scan_results > /tmp/found_wifi
echo "/usr/sbin/wpa_cli scan_results $?"

if [ "${1}" == "" ]; then
	/usr/sbin/wpa_cli scan_results | grep ":" | awk '{ print $5 "  " $3 " " $4}'
	/usr/sbin/wpa_cli terminate >/dev/null 2>&1
	return 2
fi
if [ "${2}" == "" ]; then
	/usr/sbin/wpa_cli scan_results | grep ":" | awk '{ print $5 "  " $3 " " $4}'
	/usr/sbin/wpa_cli terminate >/dev/null 2>&1
	return 3
fi
sleep 2
echo "Launching /usr/sbin/wpa_cli add_network"
/usr/sbin/wpa_cli add_network
NETWORKNUM=`/usr/sbin/wpa_cli add_network`
echo $NETWORKNUM > /tmp/networknum
NETWORKNUM=`cat /tmp/networknum  | awk '{ print $4}'`
echo "Selected NETWORKNUM = ${NETWORKNUM}"

/usr/sbin/wpa_cli << EOF
set_network ${NETWORKNUM} ssid "${1}"
set_network ${NETWORKNUM} psk "${2}"
enable_network $NETWORKNUM
save_config
EOF


sleep 1
STATUS=`/usr/sbin/wpa_cli status | grep wpa_state | sed 's/=/ /g' | awk '{ print $2}'`
echo $STATUS
/usr/sbin/wpa_cli terminate >/dev/null 2>&1
if [ "${STATUS}" == "COMPLETED" ]; then
	echo "Password Valid, wireless can be used"
	return 0
else
	echo "Password INVALID"
	return 1
fi



