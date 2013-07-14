#!/usr/local/bin/sh
#submited by shix

# Script to take console screenshots 
# Dependencies: /usr/ports/graphics/scr2png
# OS: FreeBSD

while getopts s: OPTION
 do
   case ${OPTION} in
           s) LOGFILE=${OPTARG};;
           h)
         exit 2;;
         esac
done

if [[ "$LOGFILE" = *[.png] ]]
then
        vidcontrol -p < /dev/ttyv0 > ~/shot.src

        scr2png < shot.src > ~/$LOGFILE

        rm ~/shot.src
else
        vidcontrol -p < /dev/ttyv0 > ~/shot.src

        scr2png < shot.src > ~/console_screenshot.png
 
        rm ~/shot.src
fi 
