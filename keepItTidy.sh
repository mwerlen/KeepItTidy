#!/bin/sh

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
	TV_SHOW="How I Met Your Mother"
	TV_SHOW_CODE="HIMYM"
	SEASON="8"
	EPISODE="5"
	EXTENSION="avi"
}

create_path(){
	PATH=$TV_SHOW/S$(printf "%02d" $SEASON)/${TV_SHOW_CODE}.S$(printf "%02d" $SEASON)E$(printf "%02d" $EPISODE).${EXTENSION}
}

move_file(){
	echo "Moving file to $PATH"
}

execute(){
	echo "Search path : $DIR/*";	
	for FILE in $DIR/* 
	do 
		echo "Processing $FILE file..";
		detect_pattern
		create_path
		move_file
	done
}

# Verifying if help as been requested
if [ "$1" = "-h" ] | [ "$1" = "--help" ] ; then
  usage;
fi

# Checking folder is existing
if [ -d "$1" ]; then
	DIR="$1";
fi

# If no folder specified, using current folder
if [ "$1" = "" ]; then 
	echo "No input directory specified. Using current directory"
	DIR=`pwd`;
fi

# If argument is not a directory, display usage
if [ ! -d "$DIR" ]; then
	usage;
fi

# Script execution starts
execute DIR
