# Stuur-in-e-mail.spacefm-plugin
## _Stuur in e-mail
    
    ## Requires Thunderbird, bash
    
    # Thunderbird CLI compose format :  thunderbird -compose "subject='onderwerp',body='tekst',attachment='pad1,pad2,...'"
    
    # escaping commas in attachment= doesn't work, so remove them by using symbolic 
    # links without commas to such files; as it happens, thunderbird will resolve 
    # the symbolic links and use the original filename in the message
    nocommapath=/tmp # on a multi-user system you might prefer a private directory
    attachs=()
    cleanup=()
    for a in "${fm_files[@]}"
    do
    	nocomma="${a//,/_}"
    	if [ "$a" = "$nocomma" ]
    	then # no commas to remove
    		attachs+=("$a")
    	elif [ "${a##*/}" = "${nocomma##*/}" ]
    	then	# comma is in the directory, link to a path without commas
    		ln -s -t "$nocommapath"/ "$a"
    		attachs+=("$nocommapath"/"${a##*/}")		
    		cleanup+=("$nocommapath"/"${a##*/}")		
    	else # comma is in the filename itself, replace it
    		ln -s -T "$a" "$nocommapath"/"${nocomma##*/}"
    		attachs+=( "$nocommapath"/"${nocomma##*/}")		
    		cleanup+=( "$nocommapath"/"${nocomma##*/}")		
    	fi
    done
    	# use [*], NOT [@]
    thunderbird -compose "subject='$fm_value',body='<- ${#attachs[*]} bestand(en) bijgevoegd ->',attachment='$(IFS=$','; echo "${attachs[*]}")'"
    
    # I would like to do a cleanup, but the thunderbird -compose command seems to delegate
    # to a running Thunderbird instance and exit; that is too soon to rm the symlinks
    #	 rm "${cleanup[@]}"
    
    # OLD VERSION
    #% is special for spacefm, separate it from format spec
    #stringformaat=s
    #printf reuses format as necessary to consume all of the arguments
    #thunderbird -compose "subject='$fm_value',body='<- ${#fm_files[*]} bestand(en) bijgevoegd ->',attachment='$(IFS=$','; printf "\"%$stringformaat\"" "${fm_files[*]}")'"
