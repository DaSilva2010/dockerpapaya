#!/bin/sh
EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
then
    php composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer
    RESULT=$?
    rm composer-setup.php
    echo Result: $RESULT
else
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

# install phing
EXPECTED_PHING_SIGNATURE=$(wget https://www.phing.info/get/phing-latest.phar.sha512 -O - -q)
php -r "copy('https://www.phing.info/get/phing-latest.phar', '/var/www/phing.phar');"
ACTUAL_PHING_SIGNATURE=$(php -r "echo hash_file('SHA512', '/var/www/phing.phar');")
ACTUAL_PHING_SIGNATURE="${ACTUAL_PHING_SIGNATURE} phing-latest.phar"
if [ "$EXPECTED_PHING_SIGNATURE" = "$ACTUAL_PHING_SIGNATURE" ]
then
    echo "Stored phing as /var/www/phing.phar"
else
    >&2 echo "ERROR: Invalid installer signature for phing-latest.phar -- Expected: $EXPECTED_PHING_SIGNATURE -- Actual: $ACTUAL_PHING_SIGNATURE"
    rm /var/www/phing.phar
    exit 1
fi
