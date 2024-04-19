#!/bin/bash

set -x -e

kubectl create namespace websight || true
kubectl -n websight delete secret websight-cms-admin || true
kubectl -n websight create secret generic websight-cms-admin --from-literal=WS_ADMIN_PASSWORD=pass4test

cd websight-cms

helm -n websight upgrade --install websight-cms . --set cms.customAdminSecret=admin --wait --timeout 600s

helm -n websight test websight-cms
