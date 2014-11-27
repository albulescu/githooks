#!/usr/bin/env bash

shopt -s extglob
set -e
set -o errtrace
set -o errexit

HOOKS_PATH=$(dirname $(readlink -f $0))
HOOK=`basename $0`
WORKING_DIR=$(git rev-parse --show-toplevel);
RCFILE="$WORKING_DIR/.githooksrc"

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