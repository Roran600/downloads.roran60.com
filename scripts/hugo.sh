#!/usr/bin/env bash
set -euo pipefail

./scripts/generate-file-pages.sh
exec hugo "$@"
