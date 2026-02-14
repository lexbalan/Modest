#!/bin/sh
set -e

cd "$(dirname "$0")"

find . -name Makefile -not -path ./Makefile | sort | while read makefile; do
  dir=$(dirname "$makefile")
  echo "=== $dir ==="
  make -C "$dir" test
done

echo "all tests passed"
