#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${AREN_IMAGE:-${AREN_IMAGE:-aren:local}}"
CONFIG_DIR="${AREN_CONFIG_DIR:-${AREN_CONFIG_DIR:-$HOME/.aren}}"
WORKSPACE_DIR="${AREN_WORKSPACE_DIR:-${AREN_WORKSPACE_DIR:-$HOME/.aren/workspace}}"
PROFILE_FILE="${AREN_PROFILE_FILE:-${AREN_PROFILE_FILE:-$HOME/.profile}}"

PROFILE_MOUNT=()
if [[ -f "$PROFILE_FILE" ]]; then
  PROFILE_MOUNT=(-v "$PROFILE_FILE":/home/node/.profile:ro)
fi

echo "==> Build image: $IMAGE_NAME"
docker build -t "$IMAGE_NAME" -f "$ROOT_DIR/Dockerfile" "$ROOT_DIR"

echo "==> Run live model tests (profile keys)"
docker run --rm -t \
  --entrypoint bash \
  -e COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
  -e HOME=/home/node \
  -e NODE_OPTIONS=--disable-warning=ExperimentalWarning \
  -e AREN_LIVE_TEST=1 \
  -e AREN_LIVE_MODELS="${AREN_LIVE_MODELS:-${AREN_LIVE_MODELS:-all}}" \
  -e AREN_LIVE_PROVIDERS="${AREN_LIVE_PROVIDERS:-${AREN_LIVE_PROVIDERS:-}}" \
  -e AREN_LIVE_MODEL_TIMEOUT_MS="${AREN_LIVE_MODEL_TIMEOUT_MS:-${AREN_LIVE_MODEL_TIMEOUT_MS:-}}" \
  -e AREN_LIVE_REQUIRE_PROFILE_KEYS="${AREN_LIVE_REQUIRE_PROFILE_KEYS:-${AREN_LIVE_REQUIRE_PROFILE_KEYS:-}}" \
  -v "$CONFIG_DIR":/home/node/.aren \
  -v "$WORKSPACE_DIR":/home/node/.aren/workspace \
  "${PROFILE_MOUNT[@]}" \
  "$IMAGE_NAME" \
  -lc "set -euo pipefail; [ -f \"$HOME/.profile\" ] && source \"$HOME/.profile\" || true; cd /app && pnpm test:live"
