#!/usr/bin/env bash
set -euo pipefail

cd /repo

export AREN_STATE_DIR="/tmp/aren-test"
export AREN_CONFIG_PATH="${AREN_STATE_DIR}/aren.json"

echo "==> Build"
pnpm build

echo "==> Seed state"
mkdir -p "${AREN_STATE_DIR}/credentials"
mkdir -p "${AREN_STATE_DIR}/agents/main/sessions"
echo '{}' >"${AREN_CONFIG_PATH}"
echo 'creds' >"${AREN_STATE_DIR}/credentials/marker.txt"
echo 'session' >"${AREN_STATE_DIR}/agents/main/sessions/sessions.json"

echo "==> Reset (config+creds+sessions)"
pnpm aren reset --scope config+creds+sessions --yes --non-interactive

test ! -f "${AREN_CONFIG_PATH}"
test ! -d "${AREN_STATE_DIR}/credentials"
test ! -d "${AREN_STATE_DIR}/agents/main/sessions"

echo "==> Recreate minimal config"
mkdir -p "${AREN_STATE_DIR}/credentials"
echo '{}' >"${AREN_CONFIG_PATH}"

echo "==> Uninstall (state only)"
pnpm aren uninstall --state --yes --non-interactive

test ! -d "${AREN_STATE_DIR}"

echo "OK"
