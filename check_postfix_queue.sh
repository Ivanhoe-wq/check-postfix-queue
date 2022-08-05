#!/bin/bash
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
QSHAPE=false

if ! which postqueue > /dev/null; then
	echo 'ERROR - Postfix does not appear to be installed'
	exit 1
fi

if which qshape > /dev/null; then
	QSHAPE=$(which qshape)
fi


CPATH=$(which postqueue)
MAXMSG=$1
RECIPIENT='xx@example.com'
MSG=`${CPATH} -p | tail -n1 | awk '{print $5}'`
ME=`basename "$0"`


function remove_alert_file() {
	if [ -f '.alert' ]; then
		echo 'Remove alert status' 
		rm -rf .alert
	fi
}

if [ -z $MSG ]; then
	echo 'Empty queue'
	remove_alert_file
	exit 0
fi

if [ -z $MAXMSG ]; then
	echo 'Specify a limit' 
	echo 'es. "'$ME '50"'
	exit 0
fi

if [ $MSG -gt $MAXMSG ]; then
	echo 'Err mail in coda: ' $MSG > /dev/stderr
	if [ -f '.alert' ]; then
    	echo 'Alert e-mail alredy sent'
    	exit 0
	fi
	echo "" > .alert
	QUEUE=$(postqueue -p)
	echo 'Subject: Alert' $(hostname -f) 'queue' > mail.txt
	echo 'Problem detected on sever' $(hostname -f)', e-mail queue: ' $MSG >> mail.txt
	echo -e "\n" >> mail.txt
	if [ $QSHAPE != false ]; then
		DEFF=$(qshape -s deferred)
		echo "Deferred queue status by senders: " >> mail.txt
		echo "${DEFF}" >> mail.txt
		echo -e "\n" >> mail.txt
	fi
	echo "Preview of the current queue: " >> mail.txt
	echo "${QUEUE}" >> mail.txt
	sendmail "${RECIPIENT}"  < mail.txt
	rm -rf mail.txt
	exit 1
fi

echo 'OK queue: ' $MSG 
remove_alert_file
exit 0

