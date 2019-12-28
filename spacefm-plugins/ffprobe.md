# ffprobe.spacefm-plugin
## ffprobe
    
    #ffprobe toont eigenschappen van film en geluid
    for i in %F; do xfce4-terminal -H -T "ffprobe $i" -e "/opt/ffmpeg/ffprobe -hide_banner \"$i\"" & done
