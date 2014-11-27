#!/usr/bin/env bash

if [ $HOOK != "commit-msg" ]; then exit 0; fi

REG=${INI__commits__regexp/\{\{BRANCH\}\}/$BRANCH}

if [ -n "${INI__commits__regexp}" ]; then
    if ! [[ $1 =~  $REG ]]; then
        deny "COMMITS" "Invalid commit message! Should match $REG"
    fi
fi

exit 1