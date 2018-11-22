#!/bin/bash

envsubst < /etc/nginx/conf.d/default.tmpl '${GATEWAY_URL},${AUTH_URL},${CHAT_SERVICE_URL}' > /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'