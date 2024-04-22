#!/bin/bash

CMS_NAMESPACE=${1:-"websight"}
CMS_USER=${2:-"wsadmin"}
CMS_PASSWORD=${3:-"wsadmin"}

echo "Testing WebSight CMS in: $CMS_NAMESPACE"

set -x -e

# Publish Luna Homepage
RESPONSE=$(curl -X POST http://cms.127.0.0.1.nip.io/content/luna/pages.websight-pages-space-service.publish-pages.action \
    -u  ${CMS_USER}:${CMS_PASSWORD} \
    -F "forceAction=false" \
    -F "publishAllReferences=false" \
    -F "items=Homepage" \
    -H "accept: application/json" \
    -H "Content-Type: multipart/form-data")

echo "$RESPONSE" | jq
PUBLICATION_STATUS=$(echo "$RESPONSE" | jq -r '.status')

if [ "$PUBLICATION_STATUS" == "SUCCESS" ]; then
    echo "Publication successful"
else
    echo "Failed to publish /content/luna/pages/Homepage"
    exit 1
fi

# Check http://luna.127.0.0.1.nip.io/ up to 10 times until 200 returned
TOTAL_ATTEMPTS=10
for i in $(seq 1 $TOTAL_ATTEMPTS); do
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://luna.127.0.0.1.nip.io/test.html)
    if [ "$STATUS_CODE" -eq 200 ]; then
        echo "Page http://luna.127.0.0.1.nip.io/homepage.html is up and running"
        break
    else
        echo "Attempt ${i}/${TOTAL_ATTEMPTS}: Expected 200, got $STATUS_CODE"
    fi
    if [ "$i" == "${TOTAL_ATTEMPTS}" ]; then
        echo "Page not available after $TOTAL_ATTEMPTS attempts"
        exit 1
    fi
    sleep 5
done
