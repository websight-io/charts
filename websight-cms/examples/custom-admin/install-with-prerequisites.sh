#!/bin/bash

CMS_NAMESPACE=${1:-"websight"}

echo "Installing WebSight CMS with prerequisites in: $CMS_NAMESPACE"

set -x -e

# Create namespace and secret with admin password
kubectl create namespace $CMS_NAMESPACE || true
kubectl -n $CMS_NAMESPACE delete secret websight-cms-admin || true
kubectl -n $CMS_NAMESPACE create secret generic websight-cms-admin --from-literal=WS_ADMIN_PASSWORD=pass4test

cd websight-cms
helm -n $CMS_NAMESPACE upgrade --install websight-cms . \
  -f examples/custom-admin/values.yaml \
  --wait --timeout 600s
