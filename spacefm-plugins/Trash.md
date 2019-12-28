# Trash.spacefm-plugin
## Trash
    
    # remove arguments if on one of my tmpfs mounts, else trash
    	# workaround spacefm parameter %m, cannot be escaped as \%m or %%m
    mountpt=$(stat -c %"m" %d) &&
    filesys=$(findmnt --noheadings --output SOURCE "$mountpt") &&
    [ tmpfs = "$filesys" ] &&
    	rm --force --recursive %F || 
    	batrash %F
    
