#!/usr/bin/env bash

if [ $HOOK != "commit-msg" ]; then exit 0; fi

if [ -n "${INI__commits__regexp}" ]; then

    if [[ $1 !=~ ${INI__commits__regexp} ]]; then
        deny "COMMITS" "Invalid commit message!"
    fi
fi

exit 1