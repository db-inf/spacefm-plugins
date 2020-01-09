# SmartVersion-pak-svf-uit-in.spacefm-plugin
## SmartVersion pak .svf uit in...
    
    # Pak .svf SmartVersion file uit naar gekozen directory
    # afhankelijkheden :
    #	- bash
    #	- smv op pad [SmartVersion](http://www.smartversion.com/)
    # OPM: spacefm -t --chooser heeft last met zijn argumenten : --dir en --save moeten VOOR
    #	DIR/ staan, DIR/ moet met / eindigen, en laatste paddeel van DIR/ wordt in het
    #	invulveld getoond. Maak dit zo kort en onopvallend mogelijk door het te beperken
    #	tot "."
    eval "`cd "$fm_pwd";spacefm -g --window-size 1024x800 --label 'Kies doeldirectory:' --chooser --dir --save ./ --button cancel --button ok`"
    if [ "$dialog_pressed_label" = "ok" ] 
    then
    	if [ -d "$dialog_chooser1_dir" ] 
    	then
    		if [ -w "$dialog_chooser1_dir" ]
    		then
    			svf=$(realpath %f)
    			cd "$dialog_chooser1_dir"
    			smv -x "$svf" -br "${svf%/*}"
    		else
    			>&2 echo "Kan niet schrijven naar doeldirectory \"$dialog_chooser1_dir\""
    		fi
    	else
    		>&2 echo "Dit is geen directory : \"$dialog_chooser1_dir\""
    	fi
    fi
    
