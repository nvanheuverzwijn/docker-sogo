#!/bin/bash

if [[ -n "$SOGO_CONF" ]]; then
  echo "Using environment variable 'SOGO_CONF' as content for '/etc/sogo/sogo.conf'"
  echo -n "$SOGO_CONF" > /etc/sogo/sogo.conf
fi
