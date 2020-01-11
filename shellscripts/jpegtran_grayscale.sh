#!/bin/bash
#
# Hercomprimeer een reeks jpeg-bestanden inline met jpegtran
# (doet enkel de laatste stap, de eigenlijke compressie, niet de filtering vooraf,
#  dus verliesloos)
#
# jpegtran laadt een jpg volledig in het geheugen, leidt tot swappen. linux kan hier
# niet goed mee om (kent blijkbaar random verwerkingstijd toe, zodat alle taken
# afwisselend in en uit geswapt worden; dat kan krankzinnig lang duren en zelfs
# de pc een hele tijd volledig blokkeren, ZELFS MET NICE).
# Daarom groeperen in stapelkes van 8 (mijn # kernen)
onsLockBestand=/var/lock/onzeJpegtranScripts # synchroniseren met ./jpegtran_recompress.sh
[ "${mijnFlockEnvVar}" != "$onsLockBestand" ] && exec env mijnFlockEnvVar="$onsLockBestand" flock -e "$onsLockBestand" "$0" "$@" || :

opdracht="nice jpegtran -copy none -grayscale -progressive -optimize -outfile"

# eerst per groep van 8 in parallel (laatste opdracht zonder '&', dus niet in background)
while test $# -gt 8
do
	$opdracht "$1" "$1" & $opdracht "$2" "$2" & $opdracht "$3" "$3" & $opdracht "$4" "$4" & $opdracht "$5" "$5" & $opdracht "$6" "$6" & $opdracht "$7" "$7" & $opdracht "$8" "$8" 
	shift 8
done
# overblijvende reeks, dus < 8, allemaal achter elkaar starten in background, dus parallel
while test $# -gt 0
do
	$opdracht "$1" "$1" &
	shift
done

