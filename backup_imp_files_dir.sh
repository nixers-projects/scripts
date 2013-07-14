#!/bin/bash
#submited by Shiru

#
# Configuration
#
TARGETDIR="/media/DATA/backup"
WORKDIR="/home/backup"

BACKUPDIRS="/home /root"
BACKUPFILES="/etc/fstab /etc/rc.conf"

BACKUPDIR=""
EXCLUDES="/home/niels/.gvfs /home/backup"

#
# Options
#
QUIET=false
VERBOSE=false
FORCE=false

#
# Tar command
#
tardir()
{
    local excl="$2"
    local opts=""    
    [ $VERBOSE = true ] && opts="-cPvzf" || opts="-cPzf"    
    /bin/tar $excl $opts "$BACKUPDIR/$(basename $1).tar.gz" "$1"
    #echo "$BACKUPDIR/$(basename $1).tar.gz" "$1" "$2"
    [ $? -ne 0 ] && error "Failed to tar $1"
}

#
# Print a message
#
message()
{
    [ $QUIET = false ] && echo "$1"
}

#
# An error has occured
#
error()
{
    echo "ERROR: $1!"
    if [ $FORCE = false ]; then
        echo "exiting..."
        exit 1
    fi
}

#
# Create a directory
#
mk_dir()
{
    if [ ! -d $1 ]; then
        mkdir -p $1
        [ $? -ne 0 ] && error "Could not create $1"
    fi    
}

#
# Create directories
#
mk_dirs()
{
    message "Creating directories"
    local today="$(date +%d-%m-%y)"
    BACKUPDIR=$WORKDIR/$today
    
    mk_dir $BACKUPDIR
    mk_dir $BACKUPDIR/files
    mk_dir $TARGETDIR
}

#
# Tar dirs
#
backup_dirs()
{
    for exclude in $EXCLUDES
    do
        excl="--exclude=$exclude $excl"    
    done
    
    message "Tarring directories"
    for dir in $BACKUPDIRS
    do
        tardir "$dir" "$excl"
    done
}

#
# Tar files
#
backup_files()
{
    message "Copying files to $BACKUPDIR/files"
    
    for file in $BACKUPFILES
    do    
        cp $file $BACKUPDIR/files
        [ $? -ne 0 ] && error "Failed to copy $file"    
    done    
    message "Tarring files"
    tardir $BACKUPDIR/files
    rm -rf $BACKUPDIR/files
}

#
# Move directories
#
transfer_backup()
{
    message "Moving backup to $TARGETDIR"
    mv $BACKUPDIR $TARGETDIR
    [ $? -ne 0 ] && error "Failed to move $BACKUPDIR"    
}

#
# Run backup
#
backup()
{
    message "Starting backup script..."
    message "-------------------------"
    mk_dirs
    backup_dirs
    backup_files
    transfer_backup
    message "-------------------------"
    message "Backup has finished"
}

#
# Start script
#
if [ $EUID -ne 0 ]
then
   echo "This script must be run as root" 1>&2
   exit 2
fi

while getopts ":vqe" OPT
do
    case $OPT in
    v)
        VERBOSE=true
        ;;
    q)
        QUIET=true
        ;;
    f)
        FORCE=true
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        ;;
  esac
done

backup

exit 0
