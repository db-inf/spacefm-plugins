# Copy-tab-to-panel-.spacefm-plugin
## Copy tab to panel ...
    
    [[ $fm_value =~ ^[1-4]$ ]] || { spacefm -g --label "Fout panel nummer $fm_value" --button ok; exit; }
    [ $(spacefm --socket-cmd get panel${fm_value}_visible) = 1 ] || spacefm --socket-cmd set panel${fm_value}_visible true
    spacefm --socket-cmd set --panel $fm_value new_tab  %d
