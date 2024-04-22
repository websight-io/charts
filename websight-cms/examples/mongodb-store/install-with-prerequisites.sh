#!/bin/bash
CMS_NAMESPACE=${1:-"websight"}

set -x -e

# Install and expose MongoDB
kubectl create namespace mongo
kubectl -n mongo run mongodb --image=mongo:7 \
  --env MONGO_INITDB_ROOT_USERNAME=mongoadmin \
  --env MONGO_INITDB_ROOT_PASSWORD=mongoadmin
kubectl -n mongo expose pod mongodb --port=27017 --name=mongodb

# Wait for mongo pod to be ready
kubectl -n mongo wait --for=condition=ready pod --all --timeout=300s

cd websight-cms
helm -n $CMS_NAMESPACE upgrade --install websight-cms . \
  -f examples/mongodb-store/values.yaml \
  --wait --timeout 600s --create-namespace
