#!/bin/bash

if [[ -n "$NGINX_CONF" ]]; then
  echo "Using environment variable 'NGINX_CONF' as content for '/etc/nginx/conf.d/default.conf'"
  echo -n "$NGINX_CONF" > /etc/nginx/conf.d/default.conf
fi

echo "Creating symbolic link from /var/log/nginx/access.log to /dev/stdout"
rm /var/log/nginx/access.log
ln -s /dev/stdout /var/log/nginx/access.log

echo "Creating symbolic link from /var/log/nginx/error.log to /dev/stderr"
rm /var/log/nginx/error.log
ln -s /dev/stderr /var/log/nginx/error.log
