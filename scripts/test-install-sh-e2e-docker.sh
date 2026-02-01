#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${AREN_INSTALL_E2E_IMAGE:-${AREN_INSTALL_E2E_IMAGE:-aren-install-e2e:local}}"
INSTALL_URL="${AREN_INSTALL_URL:-${AREN_INSTALL_URL:-https://aren.engineer/install.sh}}"

OPENAI_API_KEY="${OPENAI_API_KEY:-}"
ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}"
ANTHROPIC_API_TOKEN="${ANTHROPIC_API_TOKEN:-}"
AREN_E2E_MODELS="${AREN_E2E_MODELS:-${AREN_E2E_MODELS:-}}"

echo "==> Build image: $IMAGE_NAME"
docker build \
  -t "$IMAGE_NAME" \
  -f "$ROOT_DIR/scripts/docker/install-sh-e2e/Dockerfile" \
  "$ROOT_DIR/scripts/docker/install-sh-e2e"

echo "==> Run E2E installer test"
docker run --rm \
  -e AREN_INSTALL_URL="$INSTALL_URL" \
  -e AREN_INSTALL_TAG="${AREN_INSTALL_TAG:-${AREN_INSTALL_TAG:-latest}}" \
  -e AREN_E2E_MODELS="$AREN_E2E_MODELS" \
  -e AREN_INSTALL_E2E_PREVIOUS="${AREN_INSTALL_E2E_PREVIOUS:-${AREN_INSTALL_E2E_PREVIOUS:-}}" \
  -e AREN_INSTALL_E2E_SKIP_PREVIOUS="${AREN_INSTALL_E2E_SKIP_PREVIOUS:-${AREN_INSTALL_E2E_SKIP_PREVIOUS:-0}}" \
  -e OPENAI_API_KEY="$OPENAI_API_KEY" \
  -e ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY" \
  -e ANTHROPIC_API_TOKEN="$ANTHROPIC_API_TOKEN" \
  "$IMAGE_NAME"
