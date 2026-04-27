#!/usr/bin/env bash
# Thin wrapper. Canonical implementation: tools/verify_env.sh
exec "$(dirname "$0")/../../tools/verify_env.sh" "$@"
