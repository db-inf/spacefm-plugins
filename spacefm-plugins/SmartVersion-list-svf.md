# SmartVersion-list-svf.spacefm-plugin
## SmartVersion list .svf
    
    # bekijkt inhoud van .svf SmartVersion file
    # dependencies : smv op pad [SmartVersion](http://www.smartversion.com/)
    for svf in %F
    do
    	smv -lv "$svf"
    done
