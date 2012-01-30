#!/bin/sh

# This file gets the network settings from the database and stores them in /etc/dnsmasq.d/
# It also restarts dnsmasq and coovachilli if the settings have changed

NS_TEMP=$(tempfile -p grasenet -m 0644)
NS_CONF=/etc/dnsmasq.d/01-grasehotspot

# Following functions are taken from /etc/chilli/functions from the coova-chilli package

files_equal() {    # returns 0 for equal, 1 for not-equal
    [ -x /usr/bin/cmp ] || [ -x /bin/cmp ] && {
        cmp -s $1 $2 && return 0;
        return 1;
    }
    [ -x /usr/bin/md5sum ] || [ -x /bin/md5sum ] && {
        [ "$(md5sum $1 | cut -f1 -d' ')" = "$(md5sum $2 | cut -f1 -d' ')" ] && return 0;
        return 1;
    }
    return 0;
}

update_new_file() {
    files_equal $1 $2 || {
        cp -f $1 $2
        return 0;
    }
    return 1;
}

checkfornew() {
    update_new_file $NS_TEMP $NS_CONF && {
        echo "New GRASE Network Settings. Restart services";
        /etc/init.d/chilli stop || true
        /etc/init.d/dnsmasq stop || true
        echo "Waiting for them to completely shutdown...";
        sleep 2;
        /etc/init.d/chilli start || true
        /etc/init.d/dnsmasq start || true
        
    }
}

checkforerror() {
    grep -q "#error_occured" $NS_TEMP && echo "Unable to get valid network settings. Not changing Grase network settings" && return 0
}

###
[ -e /usr/share/grase/www/radmin/networksettings.dnsmasq.php ] && {
  php /usr/share/grase/www/radmin/networksettings.dnsmasq.php > $NS_TEMP
  checkforerror || checkfornew || true

  rm -f $NS_TEMP
  
}