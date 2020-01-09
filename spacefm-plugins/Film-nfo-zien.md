# Film-nfo-zien.spacefm-plugin
## Film-nfo zien
    
    ##toont de .nfo met dezelfde basisnaam als de film
    ## noch als task, noch als terminal, start b.v. mousepad :
    #/home/dirk/Documents/shellscripts/toonfilmnfo.sh %F
    
    ## als task, in spacefm popup (zie Options "X Run as task, X Popup task")
    	# sorteer "${fm_files[@]}" (same as %F), en vervang .??? door .nfo
    [ -v IFS ] && ifsOld="$IFS" || unset ifsOld
    IFS=$'
    ' nfos=($(sort -u <<<"${fm_files[*]/%.[^.][^.][^.]/.nfo}"))
    [ -v ifsOld ] && IFS="$ifsOld" || unset IFS
    	# zie mijn /bin/catfiles
    for nfo in "${nfos[@]}"
    do
    	if [[ -f "$nfo" && -r "$nfo" ]]
    	then
    		echo "${b##*/}"
    		echo "${b%/*}"
    		cat "$nfo"
    		echo -e "
    =============="
    	fi
    done
    
