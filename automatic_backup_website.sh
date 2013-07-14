#! /bin/bash
#submited by Jayro

# --- Configuration ---
NAME="unixhub__forum"                             # Name of backup
DATE=`date +%b-%d-%G-%I%p`              # Date format to append to file name

DBNAME="xxxx"                                          # Name of databse to backup
DBUSER="xxxx"                                         # Mysql user for above database
DBPASS="xxxx"                                          # Mysql password for above user

FILES="/path/to/site/files/"                           # Path to files to include in backup
 
SCPHOST="home.jr0d.com"                        # Address of remote host (IP or Domain name)
SCPUSER="backups"                                  # Account username for the above host
SCPPORT="2222"                                       # Port to use when making the SSH connection
SCPDIR="~/"                                              # Remote directory for the backup to be placed

# NOTE: Be sure you set up your ssh key on the remote machine.
#       If you have not you will be asked for the password
#       each time the script runs.

# --------------------

mysqldump -u $DBUSER -p$DBPASS $DBNAME > $FILES/$DBNAME.sql
tar cfvz $NAME-$DATE.tar.gz $FILES
scp -P $SCPPORT $NAME-$DATE.tar.gz $SCPUSER@$SCPHOST:$SCPDIR
rm $NAME-$DATE.tar.gz
rm $FILES/$DBNAME.sql

echo "Backup complete!" 
