# /etc/cron.d/grase-conf-dnsmasq: crontab fragment for grase-conf-dnsmasq
# This fetchs network settings from the database and restarts deamons if needed
# m h   dom mon dow     command

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
MAILTO=hotspot@hotspot.purewhite.id.au
## NEEDS USERNAME
*/5 *   * * *   root    /usr/share/grase/scripts/update_grase_networksettings.sh
