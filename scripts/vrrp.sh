#!/bin/sh
### BEGIN INIT INFO
# Provides:         vrrp 
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: vrrp
# Description:       HA
### END INIT INFO
. /lib/lsb/init-functions

PATH=/bin:/usr/bin:/sbin:/usr/sbin

pidvrrpd=`pidof -x vrrpd`
horodate=$(date +%d/%m/%Y_%r)
conf=/etc/vrrp.conf

if [ ! -f $conf ]; then
	log_daemon_msg "No configuration file"
	exit 0
fi 

start() {
        log_daemon_msg "."
        pidof -x vrrpd > /dev/null
        if [ $?  = 1 ]; then
        log_daemon_msg "Start vrrpd .."
 	echo -e "\n"	
	$conf > /dev/null
	log_daemon_msg "Start: done"
 	echo -e "\n"	
        else
        log_daemon_msg "vrrpd was already started ..."
        log_daemon_msg "vrrp pid: $pidvrrpd"
 	echo -e "\n"	
        fi
}

stop() {
        log_daemon_msg "."
        pidof -x vrrpd > /dev/null
        if [ $? = 0 ]; then
        log_daemon_msg "Stop vrrpd .."
 	echo -e "\n" 	
        cnt=0
	killall vrrpd
	log_daemon_msg "Exit Vrrpd: State backup and Shutting down"
 	echo -e "\n"	
        while pidof vrrpd >/dev/null
        	do
        	cnt=`expr $cnt + 1`
                        if [ $cnt -gt 60 ]
                        then
				log_daemon_msg "Can't stop vrrpd ?"
				exit 0
                        fi
                        sleep 1 
			log_daemon_msg "Please Wait" "$cnt : Pid en cours de fonctionnement " && pidof vrrpd
                done

 	echo -e "\n" 	
        log_daemon_msg "stop: done"
 	echo -e "\n" 	
        else
        log_daemon_msg "vrrpd was already stopped"
 	echo -e "\n" 	
        fi
}

case "$1" in
  start)
	start
        ;;
  stop)
	stop
        ;;

  restart|reload)
	stop
	start
	;;
 *)
        log_daemon_msg "Usage: /etc/init.d/vrrp {start|stop|restart}" >&2
	echo -e "\n"
        exit 1
        ;;
esac
exit 0
