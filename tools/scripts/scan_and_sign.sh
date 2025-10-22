#!/usr/bin/env bash
set -euo pipefail
APP=${1:-api-python-flask}
IMAGE="local/${APP}:dev"
trivy image --exit-code 1 --severity CRITICAL "$IMAGE"
cosign sign --yes "$IMAGE"
