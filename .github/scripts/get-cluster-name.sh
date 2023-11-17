#!/bin/bash

# fail fast
set -e

BRANCH_NAME=${1}

ENV_NAME=$(echo cms-chart-${BRANCH_NAME} | sed 's/[^a-zA-Z0-9]/-/g' | cut -c 1-63)
ENV_NAME=$(echo ${ENV_NAME} | tr '[:upper:]' '[:lower:]')

if [[ "$ENV_NAME" == *- ]]
then
  ENV_NAME=$(echo ${ENV_NAME} | cut -c 1-62)
  echo "${ENV_NAME}0"
else
  echo "${ENV_NAME}"
fi
