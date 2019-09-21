#!/bin/bash


SERVERNAME=$HOSTNAME
SCRIPT_NAME="$SERVERNAME - IMAP TO IMAP"
MAIL=/bin/mail;
MAIL_RECIPIENT="zkrystian@gmail.com"
LOCK_FILE="/tmp/$SERVERNAME.imapsync/estella.lockfile"
LOGFILE="imapsync_log_estella.txt"


#host1 source
HOST1=stella.home.pl
DOMAIN1=stella.home.pl


#host2 destination
HOST2=afrodyta.boost.pl
DOMAIN2=estella.eu


#domena w której znajdują się skrzynki
DOMAIN=estella.eu

####################################################
###### Nie modyfikuj poniżej tej linii
####################################################

if [ ! -e $LOCK_FILE ]; then
touch $LOCK_FILE
#Run core script

TIME_NOW=$(date +"%Y-%m-%d %T")
echo "" >> $LOGFILE
echo "------------------------------------" >> $LOGFILE
echo "IMAPSync started - $TIME_NOW" >> $LOGFILE
echo "" >> $logfile

{ while IFS=';' read u1 p1; do
USER_NAME1=$u1"@"$DOMAIN1
USER_NAME2=$u1"@"$DOMAIN2

echo "Syncing User $USER_NAME"
TIME_NOW=$(date +"%Y-%m-%d %T")
echo "Start Syncing User $u1"
echo "Starting $u1 $TIME_NOW" >> $LOGFILE
imapsync --addheader --no-modulesversion --nosyncacls --nosslcheck --syncinternaldates --host1 $HOST1 --user1 "$USER_NAME1" --password1 "$p1" --host2 $HOST2 --user2 "$USER_NAME2" --password2 "$p1" --noauthmd5
TIME_NOW=$(date +"%Y-%m-%d %T")
echo "User $USER_NAME done"
echo "Finished $USER_NAME $TIME_NOW" >> $LOGFILE
echo "" >> $LOGFILE
done ; } < estella.txt
TIME_NOW=$(date +"%Y-%m-%d %T")
echo "" >> $LOGFILE
echo "IMAPSync Finished - $TIME_NOW" >> $LOGFILE
echo "------------------------------------" >> $LOGFILE

#Koniec
#echo " IMAPSync finised" | $MAIL -s "[$SCRIPT_NAME] finished" $MAIL_RECIPIENT
rm -f $LOCK_FILE


else
TIME_NOW=$(date +"%Y-%m-%d %T")
echo "$SCRIPT_NAME at $TIME_NOW is still running" | $MAIL -s "[$SCRIPT_NAME] !!WARNING!! still running" $MAIL_RECIPIENT
echo "$SCRIPT_NAME at $TIME_NOW is still running"
fi
