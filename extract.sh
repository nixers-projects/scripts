#submited by crshd
#!/usr/bin/env bash

case $1 in
    e)
        case $2 in
            *.tar.bz2)   tar xvjf $2      ;;
            *.tar.gz)    tar xvzf $2      ;;
            *.bz2)       bunzip2 $2       ;;
            *.rar)       unrar x $2       ;;
            *.gz)        gunzip $2        ;;
            *.tar)       tar xvf $2       ;;
            *.tbz2)      tar xvjf $2      ;;
            *.tgz)       tar xvzf $2      ;;
            *.zip)       unzip $2         ;;
            *.Z)         uncompress $2    ;;
            *.7z)        7z x $2          ;;
            *)           echo "'$2' kann nicht mit >ark< entpackt werden" ;;
        esac ;;

    c)
        case $2 in
            *.tar.*)
                arch=$2
                shift 2
                tar cvf ${arch%.*} $@

                case $arch in
                    *.gz)   gzip -9r ${arch%.*}   ;;
                    *.bz2)  bzip2 -9zv ${arch%.*} ;;
                esac                                ;;

            *.rar)      shift; rar a -m5 -r $@; rar k $1    ;;
            *.zip)      shift; zip -9r $@                   ;;
            *.7z)       shift; 7z a -mx9 $@                 ;;
            *)          echo "Kein gültiger Archivtyp"      ;;
        esac ;;

    *)
        echo "WATT?" ;;
esac
