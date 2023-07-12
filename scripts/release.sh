#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --progress=plain . \
  -t votava/mongo-restic:latest \
  -t votava/mongo-restic:$(git rev-parse HEAD) \
  --push
