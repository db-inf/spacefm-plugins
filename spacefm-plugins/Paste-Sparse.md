# Paste-Sparse.spacefm-plugin
## Paste Sparse
    
    eval copied_files=$(spacefm -s get clipboard_copy_files)
    cp --recursive --sparse=always "${copied_files[@]}"  %d
