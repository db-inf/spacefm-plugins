#!/bin/bash
[ ${#@} -eq 0 -o "$1" = "-h" -o "$1" = "--help" ] && echo -e "#\tparallel.sh\n#\t===========" && cat <<-"Help" && exit -1
#	parallel.sh is a meta-script to run a command in parallel on a possibly large set of
#	arguments/filenames, with concurrency limited by the number of processors. When multiple instances
#	of parallel.sh itself are started, they execute one after the other, not in parallel.
#
#	For instance jpegtran loads a jpeg image in memory completely. When starting a large number of
#	jpegtran processes at once, this leads to swapping from RAM to disk and back. linux does
#	not handle this gracefully, because each process is alotted only small slices of execution time,
#	swapping its working memory in to an out of RAM each time. This script limits the number of
#	concurrent jpegtran processes to the number of processors.
#
#	Usage:
#
#		parallel.sh [ -h | --help ]
#		parallel.sh [ [ -e | --expansion ] expansionformat ] command... -- arguments...
#		linkingname.sh [ [ -e | --expansion ] expansionformat ] arguments...
#
#		arguments : the given or predefined command is run once for each argument (often a filename)
#		command : the executable and its options that will handle each argument in turn. Use one or more
#			"{}" options as placeholders; they will each be replaced by the argument. Each "{}" can be
#			prefixed and suffixed by fixed strings such as paths and filename extensions.
#		-e expansionformat
#		--expansion expansionformat : without this option, the arguments are collected and then expanded with
#			the bash parameter expansion syntax "${@}"; with this option, the expansionformat is inserted
#			before the closing '}'. For example, -e %.jpg would lead to the expansion of "${@%.jpg}", for
#`			which bash removes the ".jpg" suffix of each of the arguments. BEWARE: the expansion formats
#			:offset and :offset:length do NOT expand to a substring of each of the arguments; instead they
#			expand to only a subarray of the arguments.
#
#		- When invoked under it's own name 'parallel.sh', the arguments up to but not including "--" define
#		 the command to execute, wherein one or more occurences of an argument "{}", serving as placeholder,
#		 will be replaced in turn by the expansion (as documented above) of each of the arguments after "--".
#
#		- Commands can be predefined in this script, by linking to it from another filename, here called
#		 linkingname, for which the command has been defined in the case structure here-under, and
#		 invoking the script under that linkingname. Only the filename itself of the link is tested,
#		 not the path to it.
#
#	Examples:
#
#	- recompress a set of mp3 files to another directory :
#
#		`$ parallel.sh ffmpeg {} -c:a libmp3lame -vbr:a 2 /tmp/{} -- *.mp3`
#
#	- recompress a set of mp3 files to aac format; note that the expansion option first removes
#	 the .mp3 suffix, to add it again for the input option, and replacing it with .m4a for the
#	 output option to ffmpeg :
#
#		`$ parallel.sh --expansion %.??? ffmpeg -i {}.mp3 -c:a libfdk_aac -vbr:a 2 {}.m4a -- *.mp3`
#
Help

# Re-execute this script, with same arguments, under the control of flock, so that multiple parallel.sh instances do not run in parallel
# 	- the variable $parallelFlockVar signals we ARE executing under the control of flock and can continue
parallelFlockFile=/var/lock/parallelflock
[ "${parallelFlockVar}" != "$parallelFlockFile" ] && exec env parallelFlockVar="$parallelFlockFile" flock -e "$parallelFlockFile" "$0" "$@" || :

main() {
	local exp;
	# handle other options than help
	[ "$#" -ge 2 ] && [ "$1" = "-e" -o "$1" = "--expansion" ] && exp="$2" && shift 2

	# retrieve predefined commands, defined as array, for easy expansion
	# each occurence of {} or "{}" is replaced by the next argument
	case "${0##*/}" in
		# Lossless or grayscale recompress of series of jpeg images, inline
		parallel_jpegtran_recompress.sh)
			# keep colours
			command=(nice jpegtran -copy none -progressive -optimize -outfile {} {})
			;;
		parallel_jpegtran_grayscale.sh)
			# discard colours
			command=(nice jpegtran -copy none -grayscale -progressive -optimize -outfile {} {})
			;;
		*)
			# arguments upto but not including -- define the command, after the -- are the
			# set of arguments (e.g. filenames) that xargs should fill in into that command
			# at position of {}
			command=()
			while [ $# -ne 0 ] && [ "$1" != "--" ]
			do
				command+=("$1")
				shift
			done
			[ "$1" = "--" ] && shift || { >&2 echo "Command should be terminated by --"; exit -1; }
			;;
	esac
	# expand file arguments according to the --expansion argument. If none given, this reduces to "${@}"""
	eval "exp=(\"\${@$exp}\")";	# reuse the exp variable, now as array
	# print the expanded file arguments separated by null chars, and pass them on to xargs
	printf "%s\u0000" "${exp[@]}" | xargs -0 -n 1 -I\{\} -P $(nproc) "${command[@]}"
	# xargs arguments:
	#	-0	: read zero separated arguments from stdin,
	#	-n : one at a time
	#	-I : insert them in place of each {}
	#	-P : run up to nproc processes in parallel
}
main "$@"
