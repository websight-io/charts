#!/bin/bash

CMS_NAMESPACE=${1:-"websight"}
CMS_USER=${2:-"wsadmin"}
CMS_PASSWORD=${3:-"wsadmin"}

echo "Testing WebSight CMS in: $CMS_NAMESPACE"

set -x -e

# Publish Luna Homepage
RESPONSE=$(curl -X POST http://cms.127.0.0.1.nip.io/content/luna/assets/images.websight-assets-space-service.publish-assets.action \
    -u  ${CMS_USER}:${CMS_PASSWORD} \
    -F "items=LUNA.svg" \
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

# Check http://luna.127.0.0.1.nip.io/published/luna/assets/images/LUNA.svg/jcr:content/renditions/original.svg up to 10 times until 200 returned
TOTAL_ATTEMPTS=10
for i in $(seq 1 $TOTAL_ATTEMPTS); do
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://luna.127.0.0.1.nip.io/published/luna/assets/images/LUNA.svg/jcr:content/renditions/original.svg)
    if [ "$STATUS_CODE" -eq 200 ]; then
        echo "Asset LUNA.svg is pubilc!"
        break
    else
        echo "Attempt ${i}/${TOTAL_ATTEMPTS}: Expected 200, got $STATUS_CODE"
    fi
    if [ "$i" == "${TOTAL_ATTEMPTS}" ]; then
        echo "Asset not available after $TOTAL_ATTEMPTS attempts"
        exit 1
    fi
    sleep 5
done
