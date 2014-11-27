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
    
    read_ini $RCFILE 2>&1

    echo "STDERR: $?"

    echo "REGEXP: $INI__commits__regexp"

    exit 1

    if [ -n "$STDERR" ]; then 
    	notify-send -u critical -c "githooks" "Git Hooks" ".githooksrc $STDERR"
    	exit 0
    fi

    if [ -z "${INI__ALL_VARS}" ]; then
    	notify-send -u critical -c "githooks" "Git Hooks" ".githooksrc is empty!"
    	exit 0
    fi

    for f in "$HOOKS_PATH/filters/*"; do
       . $f
    done

else
	notify-send -u critical -t 7000 "Git Hooks" ".githooksrc missing!"
	exit 0
fi
