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
	echo "Dispatch all files in folder to movies or tv shows folders"
	echo "Environment variables used:"
	echo "	- KIT_TV_SHOWS_ROOT	TV Show top folder. Tv shows will be inserted as : "
	echo "				<tv_show_name>/S<season_number>/<tv_show_short_name>S<season_number>E<episode_number>.<file_extension>"
	echo "	- KIT_MOVIES_ROOT	Movies folder. All movies will be inserted as :"
	echo "				<IMBD_name> (<year>).<file_extension>"
	exit 1
}

detect_pattern(){
	#How I met	
	if [[ $FILENAME =~ [Hh]ow\.[Ii]\.[Mm]et.* ]] | [[ $FILENAME =~ HIMYM.* ]]; then
		TV_SHOW="How\ I\ Met\ Your\ Mother"
		TV_SHOW_CODE="HIMYM"
	fi

	SEASON=`echo $FILENAME | sed -e 's/\(.*\)\.S\([[:digit:]]\{1,2\}\)E\([[:digit:]]\{1,2\}\)\..*/\2/'`
	EPISODE=`echo $FILENAME | sed -e 's/\(.*\)\.S\([[:digit:]]\{1,2\}\)E\([[:digit:]]\{1,2\}\)\..*/\3/'`
	EXTENSION="${FILE##*.}"
}

create_path(){
	if [[ -n $TV_SHOW ]] & [[ $SEASON = "" ]] & [[ ! $EPISODE = "" ]] ; then 
		MOVE_PATH=$TV_SHOW/S$(printf "%02d" ${SEASON#0})/${TV_SHOW_CODE}.S$(printf "%02d" ${SEASON#0})E$(printf "%02d" ${EPISODE#0}).${EXTENSION}
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
	echo "Search path : $DIR/*";	
	for FILE in $DIR/* 
	do 
		FILENAME=`basename $FILE`	
		detect_pattern
		create_path
		move_file
		unset TV_SHOW
		unset TV_SHOW_CODE
		unset SEASON
		unset EPISODE
		unset EXTENSION
	done
}

# Verifying if help as been requested
if [[ "$1" = "-h" ]] | [[ "$1" = "--help" ]] ; then
  usage;
fi

# Checking folder is existing
if [[ -d "$1" ]]; then
	DIR="$1";
fi

# If no folder specified, using current folder
if [[ "$1" = "" ]]; then 
	echo "No input directory specified. Using current directory"
	DIR=`pwd`;
fi

# If argument is not a directory, display usage
if [[ ! -d "$DIR" ]]; then
	usage;
fi

# Script execution starts
execute DIR
