#!/bin/bash

TEMP_FILE=$(tempfile) || exit

echo "Generating coverage report in $TEMP_FILE..."

phpunit --coverage-text="$TEMP_FILE" > /dev/null

if [ "$?" == "1" ]; then
    echo "Tests failed!"
else
    if [ -f "$TEMP_FILE" ]; then

        # Take only necessary info
        INFO=$(sed -n '7,9p' < "$TEMP_FILE")

        # Delete the report file
        unlink "$TEMP_FILE"

        # Notify the coverage info
        notify-send -u critical -t 7000 "Git Hooks" "$INFO"
    fi
fi