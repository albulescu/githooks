#!/bin/bash

# enable smart regexp
shopt -s extglob

# githooks app path
HOOKS_PATH=$(dirname $(readlink -f $0))

# hook name - script name
HOOK=`basename $0`

# working directory where hooks installed
WORKING_DIR=$(git rev-parse --show-toplevel);

if [ -f "$WORKING_DIR/.githooksrc.extra" ]; then
    RCFILE="$WORKING_DIR/.githooksrc.extra"
else
    RCFILE="$WORKING_DIR/.githooksrc"
fi

# current branch in working directory
BRANCH=$(git rev-parse --abbrev-ref HEAD)

export RUNNING_UNDER_GIT_HOOK=1

# function to deny current action
deny()
{
    echo "[$1] $2"
    exit 1 
}

# load tool for parsing ini files
source "$HOOKS_PATH/read_ini.sh"

if [ -f $RCFILE ]; then
    
    # read ini file from working directory
    read_ini $RCFILE 2> /dev/null

    if [ "$INI__general__debug" == "1" ]; then
        set -x
    fi

    # check if read init fail parsing .githooksrc show notification and exit
    if [ -n "$INI_PARSE_ERROR" ]; then 
        notify-send -u critical -c "githooks" "Git Hooks" ".githooksrc $INI_PARSE_ERROR"
        exit 0
    else

        # show notification when .githooksrc is empty and exit
        if [ -z "${INI__ALL_VARS}" ]; then
            notify-send -u critical -c "githooks" "Git Hooks" ".githooksrc is empty!"
            exit 0
        fi

        # load all filters
        for filter in $(ls -v "$HOOKS_PATH/filters/"); do
            . "$HOOKS_PATH/filters/$filter"
        done
    fi
else
    # show notification when working directory has no .githooksrc
    notify-send -u critical -t 7000 "Git Hooks" ".githooksrc missing!"
    exit 0
fi
