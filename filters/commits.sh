#!/usr/bin/env bash

if [ $HOOK != "commit-msg" ]; then exit 0; fi

REG=${INI__commits__regexp/\{\{BRANCH\}\}/$BRANCH}
COMMIT=$(cat $1)

if [ -n "${REG}" ]; then
    if ! [[ $COMMIT =~  $REG ]]; then
        deny "COMMITS" "Invalid commit message! Should match $REG"
    fi
fi