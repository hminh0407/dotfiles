#!/usr/bin/env bash

COLOR_RED='\033[0;31m' # Red
COLOR_GRN='\033[0;32m' # Green
COLOR_YLW='\033[0;33m' # Yellow
COLOR_PUR='\033[0;35m' # Purple
COLOR_RST='\033[0m'    # Text Reset

verbosity=3

### verbosity levels
LEVEL_SILENT=0
LEVEL_ERROR=1
LEVEL_WARN=2
LEVEL_INFO=3
LEVEL_DEBUG=4

## esilent prints output even in silent mode
logSilent  () { verb_lvl=$LEVEL_SILENT log "$@" ;}
logError   () { verb_lvl=$LEVEL_ERROR  log "${COLOR_RED}ERROR${COLOR_RESET} ----- $@" ;}
logWarn    () { verb_lvl=$LEVEL_WARN   log "${COLOR_YLW}WARNING${COLOR_RESET} --- $@" ;}
logInfo    () { verb_lvl=$LEVEL_INFO   log "${COLOR_GRN}INFO${COLOR_RESET} ------ $@" ;}
logDebug   () { verb_lvl=$LEVEL_DEBUG  log "${COLOR_PUR}DEBUG${COLOR_RESET} ----- $@" ;}
logDumpVar () { for var in $@ ; do edebug "$var=${!var}" ; done }

function log() {
    if [ $verbosity -ge $verb_lvl ]; then
        datestring=`date +"%Y-%m-%d %H:%M:%S"`
        echo -e "$datestring - $@"
    fi
}

