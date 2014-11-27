#!/usr/bin/env bash

shopt -s extglob

HOOKS_PATH=$(dirname $(readlink -f $0))
HOOK=`basename $0`
WORKING_DIR=$(git rev-parse --show-toplevel);
RCFILE="$WORKING_DIR/.githooksrc"
BRANCH=$(git rev-parse --abbrev-ref HEAD)

deny()
{
    echo "[$1] $2"
    exit 1 
}

source "$HOOKS_PATH/read_ini.sh"

if [ -f $RCFILE ]; then
    
    read_ini $RCFILE 2> /dev/null

    if [ -n "$INI_PARSE_ERROR" ]; then 
        notify-send -u critical -c "githooks" "Git Hooks" ".githooksrc $INI_PARSE_ERROR"
        exit 0
    else

        if [ -z "${INI__ALL_VARS}" ]; then
            notify-send -u critical -c "githooks" "Git Hooks" ".githooksrc is empty!"
            exit 0
        fi

        for f in "$HOOKS_PATH/filters/*"; do
            . $f
        done
    fi
else
    notify-send -u critical -t 7000 "Git Hooks" ".githooksrc missing!"
    exit 0
fi
