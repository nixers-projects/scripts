#submited by venam
#require mplayer and a file with radio stations named radio
echo -e "\\e[0;0m\n$(cat -b radiostation|sed 's/http:/\\e[1;35m--- \\e[0;0mhttp:/')\n\n[\\e[0;34m*\\e[0;0m] Number of the radio you want to listen to:\\e[1;32m";read -p "=> " radio;mplayer $(head -n $radio radiostation | tail -1)
