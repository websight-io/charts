#!/bin/bash

set -x -e

kubectl create namespace cms || true
kubectl delete secret websight-cms-admin -n cms || true
kubectl create secret generic websight-cms-admin --from-literal=WS_ADMIN_PASSWORD=pass4test -n cms

cd websight-cms

helm upgrade --install websight-cms . -n cms --set cms.customAdminSecret=admin --wait --timeout 600s

helm test websight-cms -n cms
