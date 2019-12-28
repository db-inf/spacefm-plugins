# Del-from-Trash.spacefm-plugin
## Del from Trash
    
    ## GEEN HOTKEY, want die zou ook werken zonder dat het menu item getoond wordt; disabled buiten trash wordt toch getoond, en dat maakt onze menu's te lang. Daarom gewoon context "show in trash", en geen hotkey
    
    # if in trash files, remove trash info too, and vice versa
    # we ARE carefull to remove only when directory change succeeds
    # we don't care if files we want to delete do not exist
    # we always remove trash file before trashinfo
    #! [[ == ]] to use pattern matching
    if [[ %d == */files ]]
    then
    	rm --recursive %F
    	cd %d/../info && rm "${fm_filenames[@]/%/.trashinfo}"
    elif [[ %d == */info ]]
    then
    	pushd ../files > /dev/null && (
    		rm --recursive "${fm_filenames[@]/%.trashinfo}"
    		popd > /dev/null && rm %F
    	)
    else
    	>&2 echo "Spacefm plugin malconfigured, should run only in trash info or trash files"
    fi
