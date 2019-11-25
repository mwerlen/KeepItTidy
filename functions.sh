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

    #NCIS    
    if [[ $FILENAME =~ [Nn][Cc][Ii][Ss].* ]] ; then
        TV_SHOW="NCIS"
        TV_SHOW_CODE="NCIS"
    fi
    
    #House Of Cards    
    if [[ $FILENAME =~ [Hh]ouse[\.[:space:]][Oo]f[\.[:space:]][Cc]ards.* ]] ; then
        TV_SHOW="House of Cards"
        TV_SHOW_CODE="HoC"
    fi

    #Game of Thrones    
    if [[ $FILENAME =~ [Gg]ame[\.[:space:]][Oo]f[\.[:space:]][Tt]hrones.* ]] ; then
        TV_SHOW="Game of Thrones"
        TV_SHOW_CODE="Game.Of.Thrones"
    fi
    
    #Suits  
    if [[ $FILENAME =~ [Ss][Uu][Ii][Tt][Ss].* ]] ; then
        TV_SHOW="Suits"
        TV_SHOW_CODE="Suits"
    fi
    
    #Sherlock  
    if [[ $FILENAME =~ [Ss][hH][eE][rR][lL][oO][cC][kK].* ]] ; then
        TV_SHOW="Sherlock"
        TV_SHOW_CODE="Sherlock"
    fi
    
    #Downton Abbey  
    if [[ $FILENAME =~ [Dd]ownton[\.[:space:]][Aa]bbey[\.[:space:]]* ]] ; then
        TV_SHOW="Downton Abbey"
        TV_SHOW_CODE="Downton.Abbey"
    fi

    # True Detective 
    if [[ $FILENAME =~ [Tt]rue[\.[:space:]][Dd]etective[\.[:space:]]* ]] ; then
        TV_SHOW="True Detective"
        TV_SHOW_CODE="True.Detective"
    fi

    # Orange is the new Black
    if [[ $FILENAME =~ [Oo]range[\.[:space:]][Ii]s[\.[:space:]][Tt]he[\.[:space:]][Nn]ew[\.[:space:]][Bb]lack[\.[:space:]]* ]] ; then
        TV_SHOW="Orange Is The New Black"
        TV_SHOW_CODE="Orange.Is.The.New.Black"
    fi

    # Peaky Blinders
    if [[ $FILENAME =~ [Pp]eaky[\.[:space:]][Bb]linders[\.[:space:]]* ]] ; then
        TV_SHOW="Peaky Blinders"
        TV_SHOW_CODE="Peaky.Blinders"
    fi

    # Marvel's Agent Carter
    if [[ $FILENAME =~ [Mm]arvel[\']?s[\.[:space:]][Aa]gent[\.[:space:]][Cc]arter[\.[:space:]]* ]] ; then #' vim ne comprend pas tout !
        TV_SHOW="Marvel's Agent Carter"
        TV_SHOW_CODE="Marvels.Agent.Carter"
    fi

    # Marvel's Agent of SHIELD 
    if [[ $FILENAME =~ [Mm]arvel[\']?s[\.[:space:]][Aa]gents[\.[:space:]][Oo]f[\.[:space:]][Ss]\.?[Hh]\.?[Ii]\.?[Ee]\.?[Ll]\.?[Dd]\.?[\.[:space:]]* ]] ; then #' vim ne comprend pas tout !
        TV_SHOW="Marvel's Agents of SHIELD"
        TV_SHOW_CODE="AoS"
    fi

    # The Good Doctor
    if [[ $FILENAME =~ [Tt]he[\.[:space:]][Gg]ood[\.[:space:]][Dd]octor[\.[:space:]]* ]] ; then
        TV_SHOW="The Good Doctor"
        TV_SHOW_CODE="TGD"
    fi
    
    # The Good Place
    if [[ $FILENAME =~ [Tt]he[\.[:space:]][Gg]ood[\.[:space:]][Pp]lace[\.[:space:]]* ]] ; then
        TV_SHOW="The Good Place"
        TV_SHOW_CODE="TGP"
    fi
    
    # The Americans
    if [[ $FILENAME =~ [Tt]he[\.[:space:]][Aa]mericans[\.[:space:]]* ]] ; then
        TV_SHOW="The Americans (2013)"
        TV_SHOW_CODE="TA"
    fi
    
    # Elementary
    if [[ $FILENAME =~ [Ee]lementary[\.[:space:]]* ]] ; then
        TV_SHOW="Elementary"
        TV_SHOW_CODE="Elementary"
    fi
    
    # Chernobyl
    if [[ $FILENAME =~ [Cc]hernobyl[\.[:space:]]* ]] ; then
        TV_SHOW="Chernobyl"
        TV_SHOW_CODE="Chernobyl"
    fi
    
    # His Dark Materials
    if [[ $FILENAME =~ [Hh]is[\.[:space:]][Dd]ark[\.[:space:]][Mm]aterials[\.[:space:]]* ]] ; then
        TV_SHOW="His Dark Materials"
        TV_SHOW_CODE="HDM"
    fi

    if [[ -n $TV_SHOW ]]; then
        SEASON=`echo $FILENAME | sed -e  's/\(.*\)[sS]\([[:digit:]]\{1,2\}\)[[:space:]]\?[eE]\([[:digit:]]\{1,2\}\).*/\2/'`
        EPISODE=`echo $FILENAME | sed -e 's/\(.*\)[sS]\([[:digit:]]\{1,2\}\)[[:space:]]\?[eE]\([[:digit:]]\{1,2\}\).*/\3/'`
        EXTENSION="${FILE##*.}"
        
        #If detection don't work, use another pattern
        if [[ "$SEASON" == "$FILENAME" ]]; then            
            SEASON=`echo $FILENAME | sed -e  's/\(.*\)\([[:digit:]]\{2\}\)[[:space:]]\?[xX]\([[:digit:]]\{1,2\}\).*/\2/'`
            EPISODE=`echo $FILENAME | sed -e 's/\(.*\)\([[:digit:]]\{2\}\)[[:space:]]\?[xX]\([[:digit:]]\{1,2\}\).*/\3/'`
        fi
    fi
}

move_file(){
    if [[ -n $TV_SHOW ]] & [[ $SEASON = "" ]] & [[ ! $EPISODE = "" ]] ; then 
        TV_SHOW_FOLDER=$KIT_TV_SHOWS_ROOT/$TV_SHOW
        SEASON_FOLDER=$TV_SHOW_FOLDER/S$(printf "%02d" ${SEASON#0})
        MOVE_PATH=$SEASON_FOLDER/${TV_SHOW_CODE}.S$(printf "%02d" ${SEASON#0})E$(printf "%02d" ${EPISODE#0}).${EXTENSION}

        if [[ ! -d $TV_SHOW_FOLDER ]] ; then
            echo "Creating TV show folder : $TV_SHOW_FOLDER" 
            mkdir --mode 2750 "$TV_SHOW_FOLDER"
            #chown debian-transmission:ftpusers "$TV_SHOW_FOLDER"
            #chmod 2750 "$TV_SHOW_FOLDER"
        fi
        
        if [[ ! -d $SEASON_FOLDER ]] ; then
            echo "Creating season folder : $SEASON_FOLDER" 
            mkdir --mode 2750 "$SEASON_FOLDER"
            #chown debian-transmission:ftpusers "$SEASON_FOLDER"
            #chmod 2750 "$SEASON_FOLDER"
        fi

        echo "Moving $FILENAME to $MOVE_PATH"
        log "mv \"$FILE\" \"$MOVE_PATH\""
        #chmod 0640 "$FILE"
        # Using Rsync to set file permissions and mode
        rsync --no-group --remove-source-files --chmod=0640 "$FILE" "$MOVE_PATH"
        #chown debian-transmission:ftpusers "$MOVE_PATH"
    else
        echo "No match found for $FILENAME."
    fi
}


process_file() {
    FILE="$1"
    EXTENSION="${FILE##*.}"
    FILENAME=`basename "$FILE"`

    if [[ ! -f "$FILE" ]] ; then
        log "Found $FILE, but this is not a valid file..."
        #Not a file
        return
    fi

    log "--------------------------------"
    log "Analysing $1"
    log "Filename: $FILENAME, Extension: $EXTENSION"

    if [[ -f $FILE ]] && [[ $EXTENSION =~ (mp4)|(mkv)|(mpeg)|(avi)|(srt)|(mov)|(ass) ]] ; then
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
        if [[ -d "$FILE_L1" ]] ; then
            for FILE_L2 in "$FILE_L1"/*
            do
                process_file "$FILE_L2"
            done
        else
            process_file "$FILE_L1"
        fi
    done

    log "End of script"
}
