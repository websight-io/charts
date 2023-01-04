#!/usr/bin/env bash

docker run --rm --volume "$(pwd)/websight-cms:/helm-docs" -u $(id -u) jnorwood/helm-docs:latest && cp -r websight-cms/README.md . && rm websight-cms/README.md
