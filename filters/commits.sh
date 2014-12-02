    #!/bin/bash

if [ $HOOK == "commit-msg" ];
then

    # take regular expresstion from ini
    REG=${INI__commits__regexp/\{\{BRANCH\}\}/$BRANCH}
    
    PREPEND_BRANCH_NAME=${INI__commits__prepend_branch_name}
    PREPEND_BRANCH_DENY=${INI__commits__prepend_branch_deny}
    PREPEND_BRANCH_MATCH=${INI__commits__prepend_branch_match}
    PREPEND_BRANCH_MATCH_SUFFIX=${INI__commits__prepend_branch_match_suffix}
    PREPEND_BRANCH_MATCH_PREFIX=${INI__commits__prepend_branch_match_prefix}

    if [ "$PREPEND_BRANCH_NAME" == "1" ]; then
        
        PREPEND="$BRANCH"

        if [ -n $PREPEND_BRANCH_MATCH ]; then

            [[ $BRANCH =~ $PREPEND_BRANCH_MATCH ]]

            if [ "${#BASH_REMATCH[@]}" -eq "2" ]; then
                
                MATCH_PREPEND_BRANCH_NAME=${BASH_REMATCH[1]}

                PREPEND=$MATCH_PREPEND_BRANCH_NAME

                if [ -n $PREPEND_BRANCH_MATCH_SUFFIX ]; then
                    PREPEND="$PREPEND$PREPEND_BRANCH_MATCH_SUFFIX"
                fi
            
                if [ -n $PREPEND_BRANCH_MATCH_PREFIX ]; then
                    PREPEND="$PREPEND_BRANCH_MATCH_PREFIX$PREPEND"
                fi

                INITIAL_COMMIT=$(cat $1)

                if [ -n "$PREPEND_BRANCH_DENY" ]; then

                    if [[ $INITIAL_COMMIT =~ $PREPEND_BRANCH_DENY ]]; then
                        deny "COMMITS" "prepend_branch_name is activated and prepend_branch_deny matching your commit."
                        exit 1
                    fi
                fi

                COMMIT="$PREPEND$INITIAL_COMMIT"

                PREPEND_BRANCH_MATCH_OCCURENCES=$(grep -o $MATCH_PREPEND_BRANCH_NAME <<< $COMMIT | wc -l)

                if [ "$PREPEND_BRANCH_MATCH_OCCURENCES" != "1" ]; then
                    deny "COMMITS" "prepend_branch_name is activated and match is present twice. Try to commit without: $MATCH_PREPEND_BRANCH_NAME"
                    exit 1
                fi

                echo -n "$COMMIT" > "$1"

            else
                notify-send -u critical -t 7000 "Git Hooks" "prepend_branch_match has no match to return"
            fi
        fi
    fi

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