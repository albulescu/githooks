#!/usr/bin/env bash

if [ $HOOK != "pre-commit" ]; then exit 0; fi

echo "${INI__commits_regexp}"

exit 1