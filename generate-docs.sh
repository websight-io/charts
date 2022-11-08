#!/usr/bin/env bash

docker run --rm --volume "$(pwd)/websight-ce:/helm-docs" -u $(id -u) jnorwood/helm-docs:latest && cp -r websight-ce/README.md . && rm websight-ce/README.md
