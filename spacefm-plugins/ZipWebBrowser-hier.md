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
    
