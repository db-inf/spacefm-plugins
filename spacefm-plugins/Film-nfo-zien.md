# Film-nfo-zien.spacefm-plugin
## Film-nfo zien
    
    ##toont de .nfo met dezelfde basisnaam als de film
    ## noch als task, noch als terminal, start b.v. mousepad :
    #/home/dirk/Documents/shellscripts/toonfilmnfo.sh %F
    
    ## als task, in spacefm popup (zie Options "X Run as task, X Popup task")
    	# maak bash array van %F
    films=(%F)
    	# zie mijn /bin/catfiles
    for b in "${films[@]}"
    do
    	nfo="${b/%.[^.][^.][^.]/.nfo}"
    	if [[ -f "$nfo" && -r "$nfo" ]]
    	then
    		echo "${b##*/}"
    		echo "${b%/*}"
    		cat "$nfo"
    		echo -e "
    =============="
    	fi
    done
    
