# mv--ln----pnl3.spacefm-plugin
## mv && ln --> pnl3
    
    # verplaats geselecteerde bestanden naar panel 3, en zet symlink ernaar hier
    if [[ -n "${fm_pwd_panel[3]}" && "${fm_pwd_panel[3]}" != "${fm_pwd}"  ]]
    then
    	#lopen expliciet over alle bestanden, voor controle op succes (mv is te grof)
       for i in %N 
       do
    	# "mv" overschrijft met exitcode 0, met of zonder optie -n --no-clobber
    	# daarom testen we zelf of doel al bestaat; voor de zekerheid toch "mv -n"
          if [ ! -e "${fm_pwd_panel[3]}/$i" ] && [ ! -L "${fm_pwd_panel[3]}/$i" ] && mv -n "$i" "${fm_pwd_panel[3]}/"
          then
    		# voor de zekerheid geen -f --force
             ln -s "${fm_pwd_panel[3]}/${i}"
          else
             echo \"${i}\" bestaat al in panel 3, of move niet OK: nakijken
          fi
       done
    	## even wachten tot spacefm bijwerkt
       sleep 0.3
       spacefm --socket-cmd set --panel 3 selected_filenames %N
    #   soms handig: focus, of focus en selectie, terug naar panel 1 (context: alleen panel 1)
    	#   spacefm --socket-cmd set focused_panel 1
       spacefm --socket-cmd set --panel 1 selected_filenames %N
    else
    	echo "Open eerst in panel 3 een andere bestemmingsmap dan de map van dit panel"
    fi
    
