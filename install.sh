#!/usr/bin/env bash

set -e
set -o errtrace
set -o errexit

GITHOOKS_PATH="$HOME/githooks"
GITHOOKS_HOOK="$GITHOOKS_PATH/hook.sh"
REPO="git@github.com:albulescu/githooks.git"
CURRENT_PATH=`pwd`

log()  { printf "%b\n" "$*"; }

fail() { log "\e[91mERROR: $*\n" ; exit 1 ; }

color_light_yellow() { echo -e "\e[92m$1\e[0m"; }
color_light_red() { echo -e "\e[31m$1\e[0m"; }
color_green() { echo -e "\e[32m$1\e[0m"; }
color_cyan() { echo -e "\e[36m$1\e[0m"; }
color_dark_gray() { echo -e "\e[90m$1\e[0m"; }
color_magenta() { echo -e "\e[95m$1\e[0m"; }

link_hook() {

    echo -n "Linking $1..."
    
    if [ -L "$1" ] && [ $(readlink -f $1) == "$GITHOOKS_HOOK" ]; then 
        echo -e $(color_dark_gray "[already linked]")
        return 0
    fi

    if [ -f "$1" ];
    then
        cp "$1" "$1.backup"
        
        rm -rf $1
        
        ln -s "$GITHOOKS_HOOK" $1

        echo -n $(color_green "[linked]")

        echo $(color_magenta "[backup]")
    else

        ln -s "$GITHOOKS_HOOK" $1
        echo $(color_green "[linked]")
    fi
}

setup_hooks() {
	
    cd $CURRENT_PATH

    if git rev-parse --git-dir >& /dev/null;
    then
        
        log "Installing hook links:"

        link_hook "$CURRENT_PATH/.git/hooks/commit-msg"
        link_hook "$CURRENT_PATH/.git/hooks/post-update"
        link_hook "$CURRENT_PATH/.git/hooks/pre-commit"
        link_hook "$CURRENT_PATH/.git/hooks/prepare-commit-msg"
        link_hook "$CURRENT_PATH/.git/hooks/pre-push"
        link_hook "$CURRENT_PATH/.git/hooks/pre-rebase"
        link_hook "$CURRENT_PATH/.git/hooks/update"

    else

        fail "Current path is not a git working directory"
    fi
}

update()
{
    if [ -d "$GITHOOKS_PATH" ];
    then
        
        echo -n "Changing to $GITHOOKS_PATH and update..."

        cd $GITHOOKS_PATH

        git reset --hard >& /dev/null

        git clean -f >& /dev/null

        git pull origin master >& /dev/null

        echo $(color_green "[OK]")

    else

    	mkdir -p $GITHOOKS_PATH
        
        log "Clone hooks repository in $GITHOOKS_PATH..."

    	cd $GITHOOKS_PATH
        git init . >& /dev/null
        git remote add origin "$REPO"

        update
    fi
}

copy_rc()
{
    echo -n "Copy .githooksrc.example to working directory..."

    if [ -f "$CURRENT_PATH/.githooksrc" ]; then
        echo $(color_dark_gray "[.githooksrc found]")
        return 0;
    fi

    if [ -f "$CURRENT_PATH/.githooksrc.example" ]; then
        echo $(color_magenta "[.githooksrc.example present, please rename it!]")
        return 0;
    fi

    cp "$GITHOOKS_PATH/.githooksrc.example" $CURRENT_PATH 

    echo $(color_green "[OK]")
}

install()
{
	update 

    setup_hooks

    copy_rc

    echo $(color_green "Done, happy coding!")
}

install "$@"
