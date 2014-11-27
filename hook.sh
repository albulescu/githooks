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
    
    read_ini $RCFILE

    for f in "$HOOKS_PATH/filters/*"; do
       . $f
    done
fi