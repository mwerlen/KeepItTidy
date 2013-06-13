#!/bin/bash

#########################################################################
#                                                                       #
# KeepItTidy                                                            #
#                                                                       #
# A light shell script to keep all my movies and TV shows files tidy    #
#                                                                       #
# Author: Maxime Werlen <maxime@werlen.fr>                              #
#                                                                       #
#########################################################################
unset DEBUG


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

log() {
    if [[ -n $DEBUG ]]; then
        echo "$1"
    fi
}

detect_pattern(){
    #How I met    
    if [[ $FILENAME =~ [Hh]ow[\.[:space:]][Ii][\.[:space:]][Mm]et.* ]] || [[ $FILENAME =~ HIMYM.* ]]; then
        TV_SHOW="How I Met Your Mother"
        TV_SHOW_CODE="HIMYM"
    fi

    #House    
    if [[ $FILENAME =~ [Nn][Cc][Ii][Ss].* ]] ; then
        TV_SHOW="NCIS"
        TV_SHOW_CODE="NCIS"
    fi

    #Game of Thrones    
    if [[ $FILENAME =~ [Gg]ame[\.[:space:]][Oo]f[\.[:space:]][Tt]hrones.* ]] ; then
        TV_SHOW="Game of Thrones"
        TV_SHOW_CODE="Game.Of.Thrones"
    fi

    if [[ -n $TV_SHOW ]]; then
        SEASON=`echo $FILENAME | sed -e 's/\(.*\)S\([[:digit:]]\{1,2\}\)E\([[:digit:]]\{1,2\}\).*/\2/'`
        EPISODE=`echo $FILENAME | sed -e 's/\(.*\)S\([[:digit:]]\{1,2\}\)E\([[:digit:]]\{1,2\}\).*/\3/'`
        EXTENSION="${FILE##*.}"
    fi
}

move_file(){
    if [[ -n $TV_SHOW ]] & [[ $SEASON = "" ]] & [[ ! $EPISODE = "" ]] ; then 
        TV_SHOW_FOLDER=$KIT_TV_SHOWS_ROOT/$TV_SHOW
        SEASON_FOLDER=$TV_SHOW_FOLDER/S$(printf "%02d" ${SEASON#0})
        MOVE_PATH=$SEASON_FOLDER/${TV_SHOW_CODE}.S$(printf "%02d" ${SEASON#0})E$(printf "%02d" ${EPISODE#0}).${EXTENSION}

        if [[ ! -d $TV_SHOW_FOLDER ]] ; then
            echo "Creating TV show folder : $TV_SHOW_FOLDER" 
            mkdir "$TV_SHOW_FOLDER"
        fi
        
        if [[ ! -d $SEASON_FOLDER ]] ; then
            echo "Creating season folder : $SEASON_FOLDER" 
            mkdir "$SEASON_FOLDER"
        fi

        echo "Moving $FILENAME to $MOVE_PATH"
        log "mv $FILE $MOVE_PATH"
        mv $FILE "$MOVE_PATH"
    else
        echo "No match found for $FILENAME."
    fi
}

process_file() {
    FILE="$1"
    EXTENSION="${FILE##*.}"
    FILENAME=`basename "$FILE"`

    if [[ ! -f $FILE ]] ; then
		log "Found $FILE, but this is not a valid file..."
        #Not a file
        return
    fi

    log "--------------------------------"
    log "Analysing $1"
    log "Filename: $FILENAME, Extension: $EXTENSION"

    if [[ -f $FILE ]] && [[ $EXTENSION =~ (mp4)|(mkv)|(mpeg)|(avi)|(srt)|(mov) ]] ; then
        detect_pattern
        log "TV_SHOW : $TV_SHOW - EPISODE : $EPISODE - SEASON : $SEASON"
        move_file
    else
        log "Not a TV show file"
    fi
    
    unset TV_SHOW
    unset TV_SHOW_CODE
    unset SEASON
    unset EPISODE
    unset EXTENSION
    unset MOVE_PATH
    unset TV_SHOW_FOLDER
    unset SEASON_FOLDER
    unset FILE
    
    log ""
}

execute(){
    log "Starting up script"
    
    if [[ -n $TR_TORRENT_NAME ]] ; then
        log "####################################################"
        log "Execting script after completion of $TR_TORRENT_NAME"
        log "####################################################"
    fi

    for FILE_L1 in $DIR/*
    do
        if [[ -d $FILE_L1 ]] ; then
            for FILE_L2 in $FILE_L1/*
            do
                process_file $FILE_L2
            done
        else
            process_file $FILE_L1
        fi
    done

    log "End of script"
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

log
log "******************************************************************"

# If no folder specified, using current folder
if [[ $DIR = "" ]]; then 
    log "No input directory specified. Using current directory"
    DIR=`pwd`;
fi

# If argument is not a directory, display usage
if [[ ! -d "$DIR" ]]; then
    log "No input directory specified"
    log "Input directory : $DIR"
    usage;
fi

# If KIT_TV_SHOWS_ROOT is not a directory, display usage
if [[ ! -d "$KIT_TV_SHOWS_ROOT" ]]; then
    log "No destination directory specified"
    log "Destination directory : $KIT_TV_SHOWS_ROOT"
    usage;
fi

# Script execution starts
execute DIR
