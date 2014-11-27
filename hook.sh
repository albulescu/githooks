#!/usr/bin/env bash

HOOKS_PATH=$(dirname $(readlink -f $0))
HOOK=`basename $0`
WORKING_DIR=$(git rev-parse --show-toplevel);
RCFILE="$WORKING_DIR/.githooksrc"

source "$HOOKS_PATH/read_ini.sh"

if [ -f $RCFILE ]; then
    
    read_ini $RCFILE

    for f in "$HOOKS_PATH/filtes/*"; do
       . $f
    done
fi