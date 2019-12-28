# Mount-isosquash-op-mnt.spacefm-plugin
## Mount iso/squash op /mnt
    
    #mount een cd-image (ISO, UDF, Alcohol MDF) of een squashfs archief op /mnt
    #moet exact overeenkomen met een lijn in een /etc/sudoers.d/bestand
    mtyp="${fm_file##*.}"
    mtyp="${mtyp,,}"
    [ "$mtyp" = "squashfs" ] || mtyp="udf,iso9660"
    sudo /bin/mount -o ro -t $mtyp %f /mnt
    spacefm --socket-cmd set new_tab /mnt
    
