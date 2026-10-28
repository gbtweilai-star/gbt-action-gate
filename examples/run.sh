#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_action_gate info
PYTHONPATH=src python -m gbt_action_gate check --payload '{}'
PYTHONPATH=src python -m gbt_action_gate run   --payload '{}'
