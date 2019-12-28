# Stuur-in-e-mail.spacefm-plugin
## _Stuur in e-mail
    
    ##gewenst formaat :  thunderbird -compose "subject='onderwerp',body='tekst',attachment='pad1,pad2,...'"
    
    #attachment verdraagt geen paden met een ',' in
    thunderbird -compose "subject='$fm_value',body='<- ${#fm_files[*]} bestand(en) bijgevoegd ->',attachment='$(IFS=$','; echo "${fm_files[*]}")'"
    
    #% is special for spacefm, separate it from format spec
    #stringformaat=s
    #printf reuses format as necessary to consume all of the arguments
    #thunderbird -compose "subject='$fm_value',body='<- ${#fm_files[*]} bestand(en) bijgevoegd ->',attachment='$(IFS=$','; printf "\"%$stringformaat\"" "${fm_files[*]}")'"
