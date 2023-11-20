#!/bin/sh

set -x

# Authenticate with invalid password - request should return 401
curl -s -o /dev/null -w "%{http_code}" http://websight-cms:8080/apps/websight-authentication/j_security_check \
  --data-raw '_charset_=UTF-8&resource=%2F&j_username=wsadmin&j_password=wsadmin' \
  -ipv4 | grep '401'
