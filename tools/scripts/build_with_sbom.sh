#!/usr/bin/env bash
set -euo pipefail
APP=${1:-api-python-flask}
IMAGE="local/${APP}:dev"
docker build -t "$IMAGE" "apps/${APP}"
mkdir -p sbom
syft packages "$IMAGE" -o spdx-json > "sbom/${APP}.spdx.json"
