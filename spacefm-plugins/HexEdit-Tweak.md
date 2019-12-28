# HexEdit-Tweak.spacefm-plugin
## He_xEdit Tweak
    
    ## run in Terminal (werkt, maar zonder eigen venstertitel)
    #tweak -l %f
    
    ## run as task, open zelf terminal met bestandsnaam in venstertitel (werkt)
    # xfce4-terminal --geometry=78x51 --hide-menubar --hide-toolbar -T tweak_%n -x tweak -l %f >> "/tmp/${USER}_tweak$$_stdout" 2>> "/tmp/${USER}_tweak$$_stderr"
    
    ## run as task, open zelf terminal met bestandsnaam in venstertitel en man page in 2de tab (werkt)
    ## OPM : tweak in 2de tab krijgt foute geometry van xfce4-terminal als die tabs pas toont
    ## vanaf 2de tab (afh. van MiscAlwaysShowTabsin in ~/.config/xfce4/terminal/terminalrc)
    ## Maar in 1ste tab kan xfce4-terminal alleen opdracht uitvoeren met -e "command param",
    ## want -x, waarvoor rest van de lijn de opdracht is, kan alleen als laatste parameter.
    ## Spacefm wil geen quotes rond %n en %f, dus gebruik de overeenkomstige shell variabelen :
    xfce4-terminal --geometry=78x51 --hide-menubar --hide-toolbar -T "tweak $fm_filename" -H -e "tweak -l \"$fm_file\"" --active-tab --tab -T "man tweak" -e "man tweak"
    ## andere workaround 
    #export bestand=%f;xfce4-terminal --geometry=78x51 --hide-menubar --hide-toolbar -T tweak_%n -H -e "tweak -l \"$bestand\"" --active-tab --tab -T "man tweak" -e "man tweak"
    
