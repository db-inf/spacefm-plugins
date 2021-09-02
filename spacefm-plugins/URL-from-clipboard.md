# URL-from-clipboard.spacefm-plugin
## URL from clipboard
    
    url=$(spacefm -s get clipboard_text)
    	# escape letters after '%' to disrupt spacefm substitution
    urlfile="new link $(date +%\y%\m%\d_%\Hu%\Mm%\Ss).url"
    echo "[InternetShortcut]" >> "$urlfile"
    echo "URL=$url" >> "$urlfile"
    sleep 0.5
    spacefm -s set selected_files "$urlfile" &
