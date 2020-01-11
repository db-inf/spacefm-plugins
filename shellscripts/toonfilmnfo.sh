#!/bin/bash
# toon de nfo met dezelfde naam als de film in mousepad of andere viewer
viewer=mousepad
#seetxt is een domme txt-viewer : viewer=seetxt
# Bash shell parameter expansion 
#	$@ : alle positionele parameters vanaf 1
#	${parameter/pattern/string} : Pattern substitution (niet volgens regex, maar zoals pathname expansion); 
#		If pattern begins with  %, it must match at the end of the expanded value of parameter
#	in dit geval: vervang .xxx (met x =/= .) door .nfo
#		OPM: character classes zoals [:alnum:] en [:word:] werken niet, ondanks 'man bash'
"$viewer" "${@/%.[^.][^.][^.]/.nfo}"
#
# OPM:	Deze vangt ook andere suffixlengte dan 3-char, maar het zet alleen na de laatste de andere suffix .nfo; 
#		is dus niet geschikt voor meerdere bestandsnamen :
#	${parameter%word} : Remove shortest match of suffix pattern.
#		- The word is expanded to produce a pattern just as in pathname expansion. If the pattern 
#		matches a trailing portion of the expanded value of parameter, then the result of the
#		expansion is the expanded value of parameter with the shortest matching pattern
#		- Variant met dubbele '%%' zoekt langste match
#"$viewer" "${@%.*}.nfo"
