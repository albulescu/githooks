#GitHooks

Bash script for adding more and simple functionality to git hooks. After you install it, a file named **.githooksrc** will be copied in your project and there you can define your rules. This tool work well with [jira](https://www.atlassian.com/software/jira) where you define branch names like ***PRJ-123-feature-name***.

**The install script will clone this project into ~/githooks directory and link hooks from working directory to ~/githooks/hook.sh. The original hooks if any will be in the same directory with suffix .backup**

## Install

Execute following command in your working directory:
```sh
\curl -sSL http://tinyurl.com/githooks | bash
```

## Setup
Go to your project folder where you executed the install and rename file **.githooksrc.example** to **.githooksrc** 

Complete!

## Available filters
- Commits
- php & ruby

## Configure

```INI
[general]

; Show all commands executed by using set -x
debug=no

[commits]

; Prepend branch matched from prepend_branch_match
prepend_branch_name=yes

; Append branch name as commit suffix
; {{BRANCH}} - replaced with current branch
prepend_branch_match="^(MDR-[0-9]{3,10}).*$"


; If matches this regexp only if prepend_branch_name is on will exit with code 1
; This is to avoid adding new id to the commit.
; For example if you add 'MDR-21 message' on branch MDR-123
; the branch name will be appended and result will be MDR-123: MDR-21 message
; prepend_branch_deny="MDR-[0-9]*"

; This will add bofore the match. If match is MDR-123
; the commit message will be prepend_branch_match_prefix + MDR-123
; prepend_branch_match_prefix="-"

; This will add after the match. If match is MDR-123
; the commit message will be MDR-123 + prepend_branch_match_prefix
prepend_branch_match_suffix=": "

; Check if the current commit matches the regexp
; {{BRANCH}} - replaced with current branch
regexp="^(MDR-[0-9]{3,10}):.*$"

; Check that we commit on the right branch
; {{MATCH}} - extract first match from regexp
branch="^{{MATCH}}[^0-9]*"


[php]

; Check php file sintax
; check_sintax=yes

; Folders to exclude
; check_sintax_exclude=vendor

; Run unittests on 'commit' or 'push'
; unittest="push"

; {{WORKING_DIR}} - replaced with current dir
; unittest_command="cd {{WORKING_DIR}} && php unit"

; Notify the coverage process
; unittest_notify_coverage=yes

; If coverage is lower than. exit with code 1
; unittest_accept_min_coverage=70


[ruby]

; Remove pry debugging
; remove_pry=yes
; remove_pry_exclude="lib,.git,cache,app/cache"
```
