#!/bin/bash
## Meta-script to run a command in parallel on a possible large set of
## arguments/filenames, with concurrency limited by the number of processors.
##
## When invoked under it's own name 'parallel.sh', the arguments up to but not including -- define
## the command to execute, and the arguments after -- form the set of arguments for that command
## to operate on in parallel
##
## Commands can be predefined in this script, by linking to it from another filename, for which the command
## is set in the case structure here-under, and invoking the script under that name. Only the filename
## itself is tested, not the path to it.

# Re-execute this script, with same arguments, under the control of flock
# 	- the variable $parallelFlockVar signals we ARE executing under the control of flock and can continue
parallelFlockFile=/var/lock/parallelflock
[ "${parallelFlockVar}" != "$parallelFlockFile" ] && exec env parallelFlockVar="$parallelFlockFile" flock -e "$parallelFlockFile" "$0" "$@" || :

# predefined commands, defined as array, for easy expansion
# each occurence of {} or "{}" is replaced by the next argument
case "${0##*/}" in
	# Hercomprimeer een reeks jpeg-bestanden inline met jpegtran
	# (doet enkel de laatste stap, de eigenlijke compressie, niet de filtering vooraf,
	#  dus verliesloos)
	#
	# jpegtran laadt een jpg volledig in het geheugen, leidt tot swappen. linux kan hier
	# niet goed mee om (kent blijkbaar random verwerkingstijd toe, zodat alle taken
	# afwisselend in en uit geswapt worden; dat kan krankzinnig lang duren en zelfs
	# de pc een hele tijd volledig blokkeren, ZELFS MET NICE).
	# Daarom groeperen in stapelkes van 8 (mijn # kernen)
	parallel_jpegtran_grayscale.sh)
		# naar grijswaarden
		command=(nice jpegtran -copy none -grayscale -progressive -optimize -outfile {} {})
		#command=(echo gray "{}" "{}")
		;;
	parallel_jpegtran_recompress.sh)
		# behoudt kleuren
		command=(nice jpegtran -copy none -progressive -optimize -outfile {} {})
		#command=(echo kleur {} {})
		;;
	parallel.sh)
		## arguments upto but not including -- define the command, after the -- are the
		## set of arguments (e.g. filenames) that xargs should fill in into that command
		command=()
		while [ $# -ne 0 ] && [ "$1" != "--" ]
		do
			command+=("$1")
			shift
		done
		[ "$1" = "--" ] && shift || { >&2 echo "Command should be terminated by --"; exit -1; }
		;;
	*)	>&2 echo "Parallel-command $0 not predefined."; exit -1 ;;
esac

printf "%s\u0000" "$@" | xargs -0 -n 1 -I\{\} -P $(nproc) "${command[@]}"
