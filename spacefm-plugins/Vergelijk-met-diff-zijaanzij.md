# Vergelijk-met-diff-zijaanzij.spacefm-plugin
## Vergelijk met _diff <|>
    
    #vergelijk 2 tekstbestanden met diff, zij aan zij
    # evt. extra opties:
    #	-Z, --ignore-trailing-space
    diff --side-by-side --suppress-common-lines %F | less
