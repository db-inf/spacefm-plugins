# hexdump.spacefm-plugin
## he_xdump
    
    ## zet in xxd uitvoer een extra spatie tss. 2 blokken van 8 bytes (met evt.
    ## onvolledige laatste lijn), en offset ook in caps ABCDEF
    echo -ne "\\e]2;hexdump "%n"\\a" & xxd -g 1 -u %f | sed -E 's=^(.{8}):(.{24}) (.{24}) (.{1,16})=\U\1\E\2  \3\4=' | less
    #hexdump -C %f |less
    
