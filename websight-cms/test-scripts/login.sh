#!/bin/sh

set -x

curl -f http://websight-cms:8080/apps/websight-authentication/j_security_check \
  --data-raw '_charset_=UTF-8&resource=%2F&j_username=wsadmin&j_password=pass4test' \
  -ipv4
