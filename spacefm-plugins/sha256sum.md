# sha256sum.spacefm-plugin
## sha256sum
    
    #Toont sha256-checksums van geselecteerde bestanden in 
    #een terminalvenster
    
    # bestansdnamen eerst sorteren, om gemakkelijker te kunnen 
    # vergelijken met output van andere directory
    
    IFS=$'
    ' A=( $(printf "%s
    " %N|sort) )
    sha256sum "${A[@]}"
