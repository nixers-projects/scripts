#!/bin/bash
#submited by Shiru
#depends on wget
##################################################
#
# 4chandl
#
# Script to download all images from a 4chan thread
# By Shiru
#
##################################################

#  
# Globals
#
BOARD=
THREAD=
URL=
TDIR=

#
# Fetch HTML
#
gethtml()
{
    echo -n "Fetching $URL... "
    wget -O html.txt $URL -q 2>/dev/null
    if [ ! $? -eq 0 ]
    then
        echo "Failed"
        exit 3        
    fi
    echo "Done"
}

#
# Get all image urls and fetch them
#
fetchimages()
{
    local regex="images\.4chan\.org/$BOARD/src/[^.]*\.[jpg|png|gif]*"
    local images="$(grep -o "$regex" html.txt | uniq)"
    
    echo "Fetching images from $URL:"
    for image in $images
    do
        echo -n "Downloading $image... "
        wget http://$image $q 2>/dev/null
        [ $? -eq 0 ] && echo "done" || echo "failed"
    done
    rm html.txt
}

#
# Create directory for images
#
createdir()
{
    if [ ! -d $TDIR ]
    then
        echo -n "Creating directory: $TDIR... "
        mkdir "$TDIR"
        if [ ! $? = 0 ]
        then
            echo "failed"
            exit 2
        fi
        echo "done"
    fi    
}

#
# print usage
#
usage()
{
    if [ -z $2 ]
    then
        echo "Usage: $1 [-h ] [-b board] [-t thread] [-u url] " >&2
        exit 4
    else
        echo "Usage: $1 [-b board] [-t thread] [-u url]"
        exit 0
    fi
}

#
# Check info
#
checkopts()
{        
    if [ -z $URL ]
    then
        if [ -z $THREAD ]
        then
            echo -n "Thread: "
            read THREAD
        fi
        
        if [ -z $BOARD ]
        then
            echo -n "Board: "
            read BOARD
        fi
        URL="http://boards.4chan.org/$BOARD/res/$THREAD"
    else
        # regex for opposite of [^/res] ??
        BOARD=`echo $URL | grep -o "org/[^/res]*" | sed 's/org\///g'`
        THREAD=`echo $URL | grep -o "res/.*" | sed 's/res\///g'`
    fi
    if [ -z $BOARD ]
    then
        echo "Board not specified" >&2
        exit 3
    fi
        
    if [ -z $THREAD ]
    then
        echo "Thread not specified" >&2
        exit 3
    fi
}

#
# Parse options
#
while getopts b:t:u:h opt
do
    case "$opt" in
        b)
            BOARD="$OPTARG"
            ;;
        t)
            THREAD="$OPTARG"
            ;;
        u)
            URL="$OPTARG"
            ;;
        h)
            usage $0
            ;;
        \?)            
            exit 1
            ;;
    esac
done

checkopts $0
TDIR="$BOARD-$THREAD"

#
# Functions
#
createdir
cd "$TDIR"
gethtml
fetchimages
exit 0
