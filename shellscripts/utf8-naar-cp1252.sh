#!/bin/bash
#
# Converteer een reeks bestanden van b.v. Windows codepage 1252 naar b.v. UTF-8
# Als de conversie geen verschil maakt, blijft het origneel ongewijzigd,
# anders wordt het origineel hernoemd tot (in dit vb.) *.cp1252 en vervangen door
# de (in dit vb.) UTF-8 versie
#
# Dit script werkt alleen via een symbolic link onder een andere naam waarin
# de beide strings "codepage" vervangen zijn door bron- resp. doel-codepage,
# b.v. met de opdracht "ln -s codepage-naar-codepage cp1252-naar-utf8"
# Gebruik de opdracht "iconv -l" voor een lijst van codepages.

scriptnaam="${BASH_SOURCE[0]}"
scriptnaam=${scriptnaam##*/}
scriptnaam=${scriptnaam%.sh}
cp_bron=${scriptnaam%-naar-*}
cp_doel=${scriptnaam#*-naar-}

if [[ "$cp_bron" = "codepage" || "$cp_doel" = "codepage" ||  "$cp_bron" = "$cp_doel" ]]
then
	echo ONGELDIGE SCRIPTNAAM \"$scriptnaam\" : gelijke of niet-opgegeven codepage : ["$cp_bron"] naar ["$cp_doel"]
	exit -1
fi

geenVerschil()
{
	iconv -f "${cp_bron^^}" -t "${cp_doel^^}" "$1" | diff -q - "$1" > /dev/null
	retval_diff=$? retval_iconv="${PIPESTATUS[0]}"
	if [ $retval_iconv = 0 ]
	then
		return $retval_diff
	else
		echo "FOUT : iconv kan \"$1\" niet omzetten van [$cp_bron] naar [$cp_doel]"
		echo "       Bronbestand ongewijzigd."
		# niet omzetten == geen verschil
		return 0
	fi
}

while test $# -gt 0
do
	geenVerschil "$1" || { mv "$1" "$1.${cp_bron,,}~" && iconv -f "${cp_bron^^}" -t "${cp_doel^^}" -o "$1" "$1.${cp_bron,,}~" ; }
	shift
done

#while test $# -gt 0
#do
#	iconv -f "${cp_bron^^}" -t "${cp_doel^^}" "$1" | diff -q - "$1" || { mv "$1" "$1.${cp_bron,,}~" && iconv -f "${cp_bron^^}" -t "${cp_doel^^}" -o "$1" "$1.${cp_bron,,}~" ; }
#	shift
#done
