#!/bin/bash

CMS_NAMESPACE=${1:-"websight"}

echo "Testing WebSight CMS in: $CMS_NAMESPACE"

set -x -e

cd websight-cms
helm -n $CMS_NAMESPACE test websight-cms --filter 'name=healthcheck'
