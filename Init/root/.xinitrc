[ -f /etc/sysconfig/chromium_var ] && . /etc/sysconfig/chromium_var
[ ! -f /etc/sysconfig/chromium_var ] &&  CHROMIUM_SERVER="www.google.com"
exec google-chrome --disk-cache-dir=/dev/null --disable-low-res-tiling --kiosk ${CHROMIUM_SERVER} &
exec fluxbox

