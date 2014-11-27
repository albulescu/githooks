#!/usr/bin/env bash
if [ $HOOK == "commit-msg" ];
then

    # take regular expresstion from ini
    REG=${INI__commits__regexp/\{\{BRANCH\}\}/$BRANCH}
    
    # read commit message
    COMMIT=$(cat $1)

    if [ -n "${REG}" ]; then
        # match regular expression if present
        if ! [[ $COMMIT =~  $REG ]]; then
            deny "COMMITS" "Invalid commit message! Should match $REG"
        fi
    fi

    # if branch expresion present and regexp has no matches snow notif.
    if [ -n "${INI__commits__branch}" ] && [ ${#BASH_REMATCH[@]} -eq "1" ]; then
        notify-send -u critical -t 7000 "Git Hooks" "Option to match branch used but no match from commit regexp"
        exit 0
    fi

    # build branch match to check if commit made on right branch
    BRANCH_MATCH=${INI__commits__branch/\{\{MATCH\}\}/${BASH_REMATCH[1]}} 

    if ! [[ $BRANCH =~  $BRANCH_MATCH ]]; then
        deny "COMMITS" "Invalid commit message! Not on the right branch '$BRANCH'"
    fi
fi