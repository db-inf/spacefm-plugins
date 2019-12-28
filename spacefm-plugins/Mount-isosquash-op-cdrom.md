# Mount-isosquash-op-cdrom.spacefm-plugin
## Mount iso/squash op /cdrom
    
    #mount een cd-image (ISO, UDF, Alcohol MDF) of een squashfs archief op /cdrom
    #moet exact overeenkomen met een lijn in sudoers.d
    mtyp="${fm_file##*.}"
    mtyp="${mtyp,,}"
    [ "$mtyp" = "squashfs" ] || mtyp="udf,iso9660"
    sudo /bin/mount -o ro -t $mtyp %f /cdrom
    spacefm --socket-cmd set new_tab /cdrom
    
