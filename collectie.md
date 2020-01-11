# De hele verzameling
# Afspelen-met-VLC.spacefm-plugin
## Afspelen met VLC
    
    #hele directory of alleen directory VIDEO_TS spelen in VLC
    vlc %F

# Archiveer.spacefm-plugin
## Archiveer...
    
    file-roller -d %F

# Bekijk.spacefm-plugin
## Bekijk
    
    echo -ne "\\e]2;less "%n"...\\a" & less -- %F

# Bulk-rename.spacefm-plugin
## B_ulk rename
    
    thunar --bulk-rename %F

# Check-checksum.spacefm-plugin
## Chec_k checksum
    
    ${fm_file##*.}sum -c %n

# Checksums---file1sha256.spacefm-plugin
## Checksu_ms -> "file[1].sha256"
    
    sha256sum %N > %n.sha256

# Copy-to-ramdisk.spacefm-plugin
## Copy to _ramdisk
    
    spacefm -s run-task copy "${fm_files[@]}" /media/ramdisk

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

# Film-nfo-zien.spacefm-plugin
## Film-nfo zien
    
    ##toont de .nfo met dezelfde basisnaam als de film
    ## noch als task, noch als terminal, start b.v. mousepad :
    #/home/dirk/Documents/shellscripts/toonfilmnfo.sh %F
    
    ## als task, in spacefm popup (zie Options "X Run as task, X Popup task")
    	# sorteer "${fm_files[@]}" (same as %F), en vervang .??? door .nfo
    [ -v IFS ] && ifsOld="$IFS" || unset ifsOld
    IFS=$'
    ' nfos=($(sort -u <<<"${fm_files[*]/%.[^.][^.][^.]/.nfo}"))
    [ -v ifsOld ] && IFS="$ifsOld" || unset IFS
    	# zie mijn /bin/catfiles
    for nfo in "${nfos[@]}"
    do
    	if [[ -f "$nfo" && -r "$nfo" ]]
    	then
    		echo "${nfo##*/}"
    		echo "${nfo%/*}"
    		cat "$nfo"
    		echo -e "
    =============="
    	fi
    done
    

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
    

# ImageWrapper---file1pdf.spacefm-plugin
## ImageWrapper -> file[1].pdf
    
    #maakt 1 pdf van stel jpg en jb2
    java be.arci.pdf.ImageWrapper %N

# Java-class-decompiler.spacefm-plugin
## Java .class decompiler
    
    # Luyten GUI voor Procyon decompiler
    java -jar /home/dirk/bin/java/luyten.jar %f

# Jbig2Viewer.spacefm-plugin
## Jbig2Viewer
    
    java be.arci.jbig2.Jbig2Viewer %F

# Jbig2Writer.spacefm-plugin
## Jbig2Writer
    
    # werkt alleen voor zwart-wit
    nice java be.arci.jbig2.Jbig2Writer %F

# Jpeg-ontkleuren.spacefm-plugin
## Jpeg ontkleuren
    
    #jpegs omzetten naar grijs met JpegTrans
    nice /home/dirk/Documents/shellscripts/jpegtran_grayscale.sh %F

# Jpeg-optimalizeren.spacefm-plugin
## Jpeg optimalizeren
    
    #jpegs verliesloos hercomprimeren met JpegTran
    nice /home/dirk/Documents/shellscripts/jpegtran_recompress.sh %F

# Kriskras-met-VLC.spacefm-plugin
## Kriskras met VLC
    
    #hele directory of alleen directory VIDEO_TS spelen in VLC
    vlc  --random %F

# Mount-archief-op-mediazipmnt.spacefm-plugin
## Mount archief op /media/zipmnt
    
    # archivemount readonly zip e.d. (best geen tar.xx)
    archivemount -o readonly %f /media/zipmnt; spacefm /media/zipmnt

# Mount-isosquash-op-cdrom.spacefm-plugin
## Mount iso/squash op /cdrom
    
    #mount een cd-image (ISO, UDF, Alcohol MDF) of een squashfs archief op /cdrom
    #moet exact overeenkomen met een lijn in sudoers.d
    mtyp="${fm_file##*.}"
    mtyp="${mtyp,,}"
    [ "$mtyp" = "squashfs" ] || mtyp="udf,iso9660"
    sudo /bin/mount -o ro -t $mtyp %f /cdrom
    spacefm --socket-cmd set new_tab /cdrom
    

# Mount-isosquash-op-mnt.spacefm-plugin
## Mount iso/squash op /mnt
    
    #mount een cd-image (ISO, UDF, Alcohol MDF) of een squashfs archief op /mnt
    #moet exact overeenkomen met een lijn in een /etc/sudoers.d/bestand
    mtyp="${fm_file##*.}"
    mtyp="${mtyp,,}"
    [ "$mtyp" = "squashfs" ] || mtyp="udf,iso9660"
    sudo /bin/mount -o ro -t $mtyp %f /mnt
    spacefm --socket-cmd set new_tab /mnt
    

# PDF-comprimeren.spacefm-plugin
## PDF comprimeren
    
    #comprimeer pdf met Multivalent
    nice /home/dirk/bin/pdfcompress %F

# Paste-Sparse.spacefm-plugin
## Paste Sparse
    
    eval copied_files=$(spacefm -s get clipboard_copy_files)
    cp --recursive --sparse=always "${copied_files[@]}"  %d

# Script-in-terminal.spacefm-plugin
## _Script in terminal
    
    %f

# SmartVersion-list-svf.spacefm-plugin
## SmartVersion list .svf
    
    # bekijkt inhoud van .svf SmartVersion file
    # dependencies : smv op pad [SmartVersion](http://www.smartversion.com/)
    for svf in %F
    do
    	smv -lv "$svf"
    done

# SmartVersion-pak-svf-uit-in.spacefm-plugin
## SmartVersion pak .svf uit in...
    
    # Pak .svf SmartVersion file uit naar gekozen directory
    # afhankelijkheden :
    #	- bash
    #	- smv op pad [SmartVersion](http://www.smartversion.com/)
    # OPM: spacefm -t --chooser heeft last met zijn argumenten : --dir en --save moeten VOOR
    #	DIR/ staan, DIR/ moet met / eindigen, en laatste paddeel van DIR/ wordt in het
    #	invulveld getoond. Maak dit zo kort en onopvallend mogelijk door het te beperken
    #	tot "."
    eval "`cd "$fm_pwd";spacefm -g --window-size 1024x800 --label 'Kies doeldirectory:' --chooser --dir --save ./ --button cancel --button ok`"
    if [ "$dialog_pressed_label" = "ok" ] 
    then
    	if [ -d "$dialog_chooser1_dir" ] 
    	then
    		if [ -w "$dialog_chooser1_dir" ]
    		then
    			svf=$(realpath %f)
    			cd "$dialog_chooser1_dir"
    			smv -x "$svf" -br "${svf%/*}"
    		else
    			>&2 echo "Kan niet schrijven naar doeldirectory \"$dialog_chooser1_dir\""
    		fi
    	else
    		>&2 echo "Dit is geen directory : \"$dialog_chooser1_dir\""
    	fi
    fi
    

# Stuur-in-e-mail.spacefm-plugin
## _Stuur in e-mail
    
    ##gewenst formaat :  thunderbird -compose "subject='onderwerp',body='tekst',attachment='pad1,pad2,...'"
    
    #attachment verdraagt geen paden met een ',' in
    thunderbird -compose "subject='$fm_value',body='<- ${#fm_files[*]} bestand(en) bijgevoegd ->',attachment='$(IFS=$','; echo "${fm_files[*]}")'"
    
    #% is special for spacefm, separate it from format spec
    #stringformaat=s
    #printf reuses format as necessary to consume all of the arguments
    #thunderbird -compose "subject='$fm_value',body='<- ${#fm_files[*]} bestand(en) bijgevoegd ->',attachment='$(IFS=$','; printf "\"%$stringformaat\"" "${fm_files[*]}")'"

# Tab-on-link-target.spacefm-plugin
## Tab on link target
    
    # opent nieuwe tab op directory van link target
    # nieuwe tab wordt eerst geopend, dan wordt zijn directory gezet; 
    # we moeten dus opletten voor paden relatief t.o.v. directory van current tab
    
    doel="$(readlink %f)"
    
    if [[ -z ${doel} ]]
    then
    	doel=%d
    else
    	if [[ ${doel:0:2} == ".." ]]
    	then
    		doel="$(readlink --canonicalize %f)"
    	elif [[ ${doel:0:1} != "/" ]]
    	then
    		doel=%d/"$doel"
    	fi
    fi
    
    spacefm --socket-cmd set new_tab "${doel%/*}"
    ## even wachten tot new_tab er is
    sleep 0.3
    spacefm --socket-cmd set selected_filenames "${doel##*/}"
    

# Trash.spacefm-plugin
## Trash
    
    # remove arguments if on one of my tmpfs mounts, else trash
    	# workaround spacefm parameter %m, cannot be escaped as \%m or %%m
    #
    # requirements [batrash](https://github.com/db-inf/batrash) on your path
    mountpt=$(stat -c %"m" %d) &&
    filesys=$(findmnt --noheadings --output SOURCE "$mountpt") &&
    [ tmpfs = "$filesys" ] &&
    	rm --force --recursive %F || 
    	batrash %F
    

# Unmount-archief-op-mediazipmnt.spacefm-plugin
## Unmount archief op /media/zipmnt
    
    fusermount -u %f

# Unmount-mnt-of-cdrom.spacefm-plugin
## Unmount mnt/ of cdrom/
    
    #moet overeenkomen met een lijn in sudoers.d
    sudo umount %f

# Vergelijk-met-Meld-pnl-1-3.spacefm-plugin
## Vergelijk met Meld (pnl 1-3)
    
    #vergelijk 2 mappen of tekstbestanden met MELD
    meld "${fm_panel1_files[0]}" "${fm_panel3_files[0]}"

# Vergelijk-met-Meld.spacefm-plugin
## Vergelijk met Meld
    
    #vergelijk 2 mappen of tekstbestanden met MELD
    meld %F

# Vergelijk-met-WinMerge-wine.spacefm-plugin
## Vergelijk met WinMerge (wine)
    
    #opent WinMerge; playonlinux mount linux root op windows schijfletter Z:
    /usr/share/playonlinux/playonlinux --run "WinMerge" /r /x /u "Z:${fm_files[0]}" "Z:${fm_files[1]}"

# ZipWebBrowser-hier.spacefm-plugin
## _ZipWebBrowser hier
    
    cd ~/Documents/java/ZipWebServer
    if [ -d %f ]
    then
    	echo Stop de server met url 127.0.0.3:8080/server?stop
    	firefox -new-window 127.0.0.3:8080 &
    	java be.arci.zipweb.Server  SERVER=127_0_0_3__8080_vanaf_root.properties SERVER_ROOT=%f
    else
    	echo Stop de server met url 127.0.0.3:8080/server?stop
    	firefox -new-window 127.0.0.3:8080/%N!/ &
    	java be.arci.zipweb.Server  SERVER=127_0_0_3__8080_vanaf_root.properties SERVER_ROOT=%d
    fi
    

# cp1252---utf-8.spacefm-plugin
## cp1252 -> utf-8
    
    #Converteer in place van Windows 1252 naar UTF-8, met backup naar .cp1252 bij wijzigingen
    /home/dirk/Documents/shellscripts/cp1252-naar-utf8.sh %F

# exec-in-Wine-Win7x86PROGS.spacefm-plugin
## exec in Wine (Win7x86PROGS)
    
    #voert een Windows .bat, .exe of .com uit
    /usr/share/playonlinux/playonlinux --run "execute in Win7x86PROGS" %f

# ffprobe.spacefm-plugin
## ffprobe
    
    #ffprobe toont eigenschappen van film en geluid
    # afhankelijkheden : 
    # - bash : om de terminal niet expliciet open te moeten houden (en dan expliciet te sluiten)
    # 	gebruik ik bash om naar less te pipen, zodat terminal sluit door in less 'q' te typen
    # - ffprobe (ffmpeg)
    
    ## version 1 : -H(old) terminal open, close explicitely
    #for i in %F; do xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar -H -T "ffprobe $i" -e "ffprobe -hide_banner \"$i\"" & done
    
    ## mijn favoriet
    ## version 2 : terminal window per file, use less to hold window open until 'q' typed
    #for i in %F; do xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar -T "ffprobe $i" -e "bash -c \"ffprobe -hide_banner \\\"$i\\\" 2>&1 | less\"" & done
    # met nadruk op een paar gegevens
    for i in %F; do xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar -T "ffprobe $i" -e "bash -c \"ffprobe -hide_banner \\\"$i\\\" 2>&1 | grep --colour=always -E -e 'Duration[^[:alpha:]]+' -e '[0-9]+ Hz' -e '[0-9.]+ kb[/p]s' -e 'Stream [^,]+(,|$)' -e ', [0-9]+x[0-9]+( \[.+])?,' -e '^' | less -R\"" & done
    
    ## version 3 : single terminal window with tabs
    #termtabs=()
    #for i in %F
    #do
    #	[ ${#termtabs[*]} = 0 ] || termtabs+=(--tab)
    #	termtabs+=(-T "\"ffprobe $i\"" -e "bash -c \"ffprobe -hide_banner \\\"$i\\\" 2>&1 | less\"")
    #done
    #xfce4-terminal --hide-menubar --hide-toolbar --hide-scrollbar "${termtabs[@]}" &
    
    

# hexdump.spacefm-plugin
## hexdump
    
    echo -ne "\\e]2;hexdump "%n"\\a" & hexdump -C %f |less

# ibm850---utf-8.spacefm-plugin
## ibm850 -> utf-8
    
    #Converteer in place van IBM850 naar UTF-8, met backup naar .ibm850 bij wijzigingen
    /home/dirk/Documents/shellscripts/ibm850-naar-utf8.sh %F

# markdown-browse.spacefm-plugin
## markdown browse
    
    md2html %f

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
    
    else
    	echo "Open eerst in panel 3 een andere bestemmingsmap dan de map van dit panel"
    fi
    

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

# tarxz-HIER.spacefm-plugin
## tar.xz HIER
    
    file-roller -a %f.tar.xz %F

# utf-8---cp1252.spacefm-plugin
## utf-8 -> cp1252
    
    #Converteer in place van UTF-8 naar Windows 1252, met backup naar .utf8 bij wijzigingen
    /home/dirk/Documents/shellscripts/utf8-naar-cp1252.sh %F

# Bekijk-less.spacefm-file-handler
## Bekijk (less)
    

# Open-in-Firefox.spacefm-file-handler
## Open in Firefox
    

