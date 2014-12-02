#!/bin/bash

PHP_UNITTEST=${INI__php__unittest}
PHP_UNITTEST_NOTIFY_COVERAGE=${INI__php__unittest_notify_coverage}

if [ "$PHP_UNITTEST" == "$HOOK" ]; then

    phpunit > /dev/null

    UNIT_STATUS=$?

    if [ "$UNIT_STATUS" == "1" ]; then
        deny "PHP" "Unit tests fail!"
        exit 1
    fi

    if [ -n $PHP_UNITTEST_NOTIFY_COVERAGE ]; then
        . "$HOOKS_PATH/addons/php-coverage-notify.sh" &
    fi
fi
