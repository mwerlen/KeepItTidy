#!/bin/bash
 
. ../functions.sh

function move_file() {
    #Never realy move file during tests...
    assertEquals "HIMYM" "$TV_SHOW_CODE"
}

function check_season_episode() {
    assertEquals "$TEST_SEASON" "$SEASON"
    assertEquals "$TEST_EPISODE" "$EPISODE"
}

function check_HIMYM() {
    #Given $FILENAME
    TEST_SEASON=$1
    TEST_EPISODE=$2

    #When
    detect_pattern

    #Then
    assertEquals "How I Met Your Mother" "$TV_SHOW"
    assertEquals "HIMYM" "$TV_SHOW_CODE"

    check_season_episode
}
 
function test_detect_pattern () {
    FILENAME="How I Met S02E01 Where Were We.avi"
    check_HIMYM    02 01    
    
    FILENAME="How.I.Met.Your.Mother.S08E05.VOSTFR.HDTV.XviD-AFG.avi"
    check_HIMYM 08 05

    FILENAME="how.i met your mother s4e5.avi"
    check_HIMYM 4 5

    FILENAME="how.I.Met.06x12.avi"
    check_HIMYM 06 12
    
    FILENAME="how.I.Met.11x12.avi"
    check_HIMYM 11 12
}

function check_code () {
    #Given
    FILENAME=$1
    TEST=$2

    #When
    detect_pattern
    
    #Then
    assertEquals "$TEST" "$TV_SHOW_CODE" 
}

function test_detect_pattern_all () {
    check_code "Game.of.Thrones.S03E07.PROPER.VOSTFR.HDTV.XviD-ATeam.avi" "Game.Of.Thrones" 
    check_code "HIMYM.S02E4.mov" "HIMYM"
    check_code "Sherlock.S01E01.avi" "Sherlock"
    check_code "NCIS.S01E01.avi" "NCIS"
    check_code "Marvel's Agent Carter.S01E01.FASTSUB.VOSTFR.1080p.WEB-DL.DD5.1.H.264-BEURACK.mkv" "Marvels.Agent.Carter"
    check_code "Orange.Is.The.New.Black.S01E01.VOSTFR.DVDRip.X264-PM5" "Orange.Is.The.New.Black"
    check_code "Peaky.Blinders.S01E01.VOSTFR.720p.HDTV.x264-GKS.mkv" "Peaky.Blinders"
    check_code "Marvels.Agent.Carter.S01E03.FASTSUB.VOSTFR.HDTV.XviD-ATN.avi" "Marvels.Agent.Carter"
    check_code "Marvels.Agents.of.S.H.I.E.L.D.S04E10.SUBFRENCH.WEB-DL.x264-ARK01.mp4" "AoS"
    check_code "The.Good.Doctor.S01E06.FASTSUB.VOSTFR.720p.HDTV.x264-FDS.mkv" "TGD"
    check_code "/media/disk/downloads/[www.Cpasbien.com] Elementary.S01E01.PILOT.FASTSUB.VOSTFR.DVDSCR.XviD-Xtrem/[www.Cpasbien.com] Elementary.S01E01.PILOT.FASTSUB.VOSTFR.DVDSCR.XviD-Xtrem.avi" "Elementary"
    check_code "His.Dark.Materials.S01E03.MULTi.1080p.WEBRip.x265-R3MiX.mkv" "HDM"
}

function test_process_file() {
    #Given
    FILE="./testFolder/How I Met S02E01 Where Were We.avi"

    #When
    process_file "$FILE"

    #Then
    #move_file function will assert success
}

function test_execute() {
    #Given
    DIR=./testFolder

    #When
    execute
    
    #Then
    #move_file function will assert success
}
 
## Call and Run all Tests
. shunit2
