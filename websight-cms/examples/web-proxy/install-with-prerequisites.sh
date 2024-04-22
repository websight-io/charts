#!/bin/bash

CMS_NAMESPACE=${1:-"websight"}

echo "Installing WebSight CMS with prerequisites in: $CMS_NAMESPACE"

set -x -e

# Install Kind-dedicated NgInx Ingress Controller and wait until it's ready
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl -n ingress-nginx rollout status deployment ingress-nginx-controller

# Create namespace and configure Nginx proxy via ConfigMap
kubectl create namespace $CMS_NAMESPACE || true

cd websight-cms
kubectl -n $CMS_NAMESPACE create configmap luna-site-config \
  --from-file=examples/web-proxy/luna-site.conf.template

helm -n $CMS_NAMESPACE upgrade --install websight-cms . \
  -f examples/web-proxy/values.yaml \
  --wait --timeout 600s
