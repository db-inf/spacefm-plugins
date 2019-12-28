# Tab-on-link-target.spacefm-plugin
## Tab on link target
    
    # opent nieuwe tab op directory van link target
    # nieuwe tab wordt eerst geopend, dan wordt zijn directory gezet; 
    # we moeten dus opletten voor paden relatief t.o.v. directory van current tab
    
    doel="$(readlink %f)"
    
    if [[ -z ${doel} ]]
    then
    	doel=%d
    else
    	if [[ ${doel:0:2} == ".." ]]
    	then
    		doel="$(readlink --canonicalize %f)"
    	elif [[ ${doel:0:1} != "/" ]]
    	then
    		doel=%d/"$doel"
    	fi
    fi
    
    spacefm --socket-cmd set new_tab "${doel%/*}"
    ## even wachten tot new_tab er is
    sleep 0.3
    spacefm --socket-cmd set selected_filenames "${doel##*/}"
    
