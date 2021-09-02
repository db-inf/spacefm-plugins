# tail-VanDale.spacefm-plugin
## tail VanDale
    
    xfce4-terminal --geometry=40x20 --hide-menubar --hide-toolbar -T tail_%n -e "bash -ic 'tail -F %f | grep -E \"^<<<\"'"
