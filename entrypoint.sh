#!/bin/bash

: "${PAPAYA_DB_HOST:=mysql}"
: ${PAPAYA_DB_USER:=${MYSQL_ENV_MYSQL_USER:-root}}
if [ "$PAPAYA_DB_USER" = 'root' ]; then
  : ${PAPAYA_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
fi

: ${PAPAYA_DB_PASSWORD:=$MYSQL_ENV_MYSQL_PASSWORD}
: ${PAPAYA_DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-papaya}}

if [ -z "$PAPAYA_DB_PASSWORD" ]; then
  echo >&2 'error: missing required PAPAYA_DB_PASSWORD environment variable'
  echo >&2 '  Did you forget to -e PAPAYA_DB_PASSWORD=... ?'
  echo >&2
  echo >&2 '  (Also of interest might be PAPAYA_DB_USER and PAPAYA_DB_NAME.)'
  exit 1
fi

cd /var/www/dockerpapaya
sed "s/ext:\/\/username:password@host\/database/mysql:\/\/$PAPAYA_DB_USER:$PAPAYA_DB_PASSWORD@mysql\/$PAPAYA_DB_NAME/g" dist.build.properties > build.properties
phing

cd /var/www
chown -R www-data:www-data dockerpapaya
chmod -R 0777 dockerpapaya/papaya-data

#rm -r papayacms-core-master
/usr/sbin/apache2ctl -D FOREGROUND
