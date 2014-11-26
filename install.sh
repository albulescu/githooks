#!/usr/bin/env bash

shopt -s extglob
set -o errtrace
set -o errexit

GITHOOKS_PATH="$HOME/githooks"
REPO="git@github.com:albulescu/githooks.git"


log()  { printf "%b\n" "$*"; }
debug(){ [[ ${rvm_debug_flag:-0} -eq 0 ]] || printf "%b\n" "Running($#): $*"; }
fail() { log "\nERROR: $*\n" ; exit 1 ; }

setup_hooks() {
	
}

update()
{
	mkdir -p $GITHOOKS_PATH
	
	cd $GITHOOKS_PATH

	git clone "$REPO"
}

install()
{
	update 
}

install "$@"
