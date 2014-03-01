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

MY_DIR=$(dirname $(readlink -f $0))

$MY_DIR/functions.sh

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
