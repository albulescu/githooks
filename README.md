#GitHooks

Bash script for adding more and simple functionality to git hooks. After you install it, a file named **.githooksrc** will be copied in your project and there you can define your rules.

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
- UnitTest Runner ( todo )

## Configure

```INI
[commits]

; Check if the current commit matches the regexp
; {{BRANCH}} - replaced with current branch
regexp="^(MDR-[0-9]{3,10}):.*$"

; Check that we commit on the right branch
; {{MATCH}} - extract first match from regexp
branch="^{{MATCH}}[^0-9]"
```
