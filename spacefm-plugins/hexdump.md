# hexdump.spacefm-plugin
## hexdump
    
    echo -ne "\\e]2;hexdump "%n"\\a" & hexdump -C %f |less
