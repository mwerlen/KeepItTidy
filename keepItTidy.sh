#!/bin/bash

#########################################################################
#									#
# KeepItTidy								#
#									#
# A light shell script to keep all my movies and TV shows files tidy	#
#									#
# Author: Maxime Werlen <maxime@werlen.fr>				#
#									#
#########################################################################

usage(){
	echo "Usage: $0 [folder]"
    echo ""
    echo "Dispatch all files in folder to movies or tv shows folders"
    echo ""
	echo "Options"
	echo "  -d --debug  Debug mode"
	echo "  -h --help   Print Usage"	
    echo ""
    echo "Environment variables used:"
	echo "  KIT_TV_SHOWS_ROOT   TV Show top folder. Tv shows will be inserted as : "
	echo "      <tv_show_name>/S<season_number>/<tv_show_short_name>S<season_number>E<episode_number>.<file_extension>"
	exit 1
}

detect_pattern(){
	#How I met	
	if [[ $FILENAME =~ [Hh]ow[\.[:space:]][Ii][\.[:space:]][Mm]et.* ]] || [[ $FILENAME =~ HIMYM.* ]]; then
		TV_SHOW="How\ I\ Met\ Your\ Mother"
		TV_SHOW_CODE="HIMYM"
	fi

	#House	
	if [[ $FILENAME =~ [Nn][Cc][Ii][Ss].* ]] ; then
		TV_SHOW="NCIS"
		TV_SHOW_CODE="NCIS"
	fi

	#Game of Thrones	
	if [[ $FILENAME =~ [Gg]ame[\.[:space:]][Oo]f[\.[:space:]][Tt]hrones.* ]] ; then
		TV_SHOW="Game\ of\ Thrones"
		TV_SHOW_CODE="Game.Of.Thrones"
	fi

	if [[ -n $TV_SHOW ]]; then
		SEASON=`echo $FILENAME | sed -e 's/\(.*\)S\([[:digit:]]\{1,2\}\)E\([[:digit:]]\{1,2\}\).*/\2/'`
		EPISODE=`echo $FILENAME | sed -e 's/\(.*\)S\([[:digit:]]\{1,2\}\)E\([[:digit:]]\{1,2\}\).*/\3/'`
		EXTENSION="${FILE##*.}"
	fi

	if [[ -n $DEBUG ]]; then
		echo "TV_SHOW : $TV_SHOW"
		echo "EPISODE : $EPISODE"
		echo "SEASON : $SEASON"
	fi
}

create_path(){
	if [[ -n $TV_SHOW ]] & [[ $SEASON = "" ]] & [[ ! $EPISODE = "" ]] ; then 
		MOVE_PATH=$KIT_TV_SHOWS_ROOT/$TV_SHOW/S$(printf "%02d" ${SEASON#0})/${TV_SHOW_CODE}.S$(printf "%02d" ${SEASON#0})E$(printf "%02d" ${EPISODE#0}).${EXTENSION}
	fi
}

move_file(){
	if [[ $MOVE_PATH ]]; then
		echo "Moving $FILENAME to $MOVE_PATH"
	else
		echo "No match found for $FILENAME."
	fi
}

execute(){
	for FILE in $DIR/* 
	do 
		if [[ -n $DEBUG ]]; then
			echo "--------------------------------"
			echo "Analysing $FILE"
		fi
		FILENAME=`basename "$FILE"`	
		detect_pattern
		create_path
		move_file
		unset TV_SHOW
		unset TV_SHOW_CODE
		unset SEASON
		unset EPISODE
		unset EXTENSION
		unset MOVE_PATH
	done
}

# Verifying if help as been requested
if [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]] ; then
	usage;
fi

# debug
if [[ $1 = "-d" ]] || [[ $1 = "--debug" ]] ; then
	DEBUG="yep"
	DIR=$2
else
	DIR=$1
fi

# If no folder specified, using current folder
if [[ $DIR = "" ]]; then 
	echo "No input directory specified. Using current directory"
	DIR=`pwd`;
fi

# If argument is not a directory, display usage
if [[ ! -d "$DIR" ]]; then
	usage;
fi

# If KIT_TV_SHOWS_ROOT is not a directory, display usage
if [[ ! -d "$KIT_TV_SHOWS_ROOT" ]]; then
	usage;
fi



# Script execution starts
execute DIR
