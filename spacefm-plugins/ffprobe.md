# ffprobe.spacefm-plugin
## ffprobe
    
    #ffprobe toont eigenschappen van film en geluid
    # afhankelijkheden : 
    # - bash : om de terminal niet expliciet open te moeten houden (en dan expliciet te sluiten)
    # 	gebruik ik bash om naar less te pipen, zodat terminal sluit door in less 'q' te typen
    # - ffprobe (ffmpeg)
    
    ## version 1 : -H(old) terminal open, close explicitely
    #for i in %F; do xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar -H -T "ffprobe $i" -e "ffprobe -hide_banner \"$i\"" & done
    
    ## mijn favoriet
    ## version 2 : terminal window per file, use less to hold window open until 'q' typed
    #for i in %F; do xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar -T "ffprobe $i" -e "bash -c \"ffprobe -hide_banner \\\"$i\\\" 2>&1 | less\"" & done
    # met nadruk op een paar gegevens
    for i in %F; do xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar -T "ffprobe $i" -e "bash -c \"ffprobe -hide_banner \\\"$i\\\" 2>&1 | grep --colour=always -E -e 'Duration[^[:alpha:]]+' -e '[0-9]+ Hz' -e '[0-9.]+ kb[/p]s' -e 'Stream [^,]+(,|$)' -e ', [0-9]+x[0-9]+( \[.+])?,' -e '^' | less -R\"" & done
    
    ## version 3 : single terminal window with tabs
    #termtabs=()
    #for i in %F
    #do
    #	[ ${#termtabs[*]} = 0 ] || termtabs+=(--tab)
    #	termtabs+=(-T "\"ffprobe $i\"" -e "bash -c \"ffprobe -hide_banner \\\"$i\\\" 2>&1 | less\"")
    #done
    #xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar "${termtabs[@]}" &
    
    
