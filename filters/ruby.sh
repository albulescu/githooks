#!/bin/bash

if [ $HOOK == "pre-push" ] && [ "$INI__ruby__remove_pry" == "1" ];
then
    
    FOUND=$(grep -Rn --exclude-dir={"${INI__ruby__remove_pry_exclude}"} "binding.pry" 2> /dev/null)

    if [ -n "$FOUND" ]; then
      deny "RUBY" "Found binding.pry. Remove it"
      exit 1
    fi
fi
