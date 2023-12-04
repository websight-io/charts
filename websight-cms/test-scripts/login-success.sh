#!/bin/sh

set -x

# Authenticate with valid password - request should return 200
curl -f http://websight-cms-cms:8080/apps/websight-authentication/j_security_check \
  --data-raw '_charset_=UTF-8&resource=%2F&j_username=wsadmin&j_password=pass4test' \
  -ipv4
