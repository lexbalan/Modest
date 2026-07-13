#!/bin/bash
# Profile mcc compilation of the sha256 test.
# Usage: ./profile.sh [--top N]   (default: top 20 functions)

set -e
cd "$(dirname "$0")"

TOP=${1:-20}
PROF_OUT=/tmp/modest_profile.out
MAIN_PY="$MODEST_DIR/src/main.py"

source "$MODEST_DIR/venv/bin/activate"

run_profile() {
    local label="$1"; shift
    echo ""
    echo "=== $label ==="
    python -m cProfile -o "$PROF_OUT" "$MAIN_PY" "$@" 2>/dev/null
    python - "$PROF_OUT" "$TOP" <<'EOF'
import pstats, sys
p = pstats.Stats(sys.argv[1], stream=sys.stdout)
p.strip_dirs().sort_stats('cumulative').print_stats(int(sys.argv[2]))
EOF
}

run_profile "main.m (c11)"   -o out/c/main   -mbackend=c11 -funsafe src/main.m
run_profile "sha256.m (c11)" -o out/c/sha256 -mbackend=c11 -funsafe "$MODEST_LIB/misc/sha256.m"

deactivate
