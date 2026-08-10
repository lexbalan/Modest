#!/bin/sh
set -e

MODEST_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

PYTHON=python3

BEGIN_MARK="# >>> Modest >>>"
END_MARK="# <<< Modest <<<"


# Environment variables go into a marker-delimited block, so that re-running
# this script replaces the old block instead of appending a second copy.

write_env_block() {
	rc=$1
	tmp="$rc.modest.tmp"

	if [ -f "$rc" ]; then
		awk -v b="$BEGIN_MARK" -v e="$END_MARK" '
			$0 == b { skip = 1 }
			!skip   { print }
			$0 == e { skip = 0 }
		' "$rc" > "$tmp"
		cat "$tmp" > "$rc"
		rm -f "$tmp"
	fi

	# do not glue the block onto an unterminated last line
	if [ -s "$rc" ] && [ -n "$(tail -c 1 "$rc")" ]; then
		printf '\n' >> "$rc"
	fi

	{
		printf '%s\n' "$BEGIN_MARK"
		printf 'export MODEST_DIR="%s"\n' "$MODEST_DIR"
		printf 'export MODEST_LIB="$MODEST_DIR/lib"\n'
		printf 'export PATH="$PATH:$MODEST_DIR"\n'
		printf '%s\n' "$END_MARK"
	} >> "$rc"
}


# Python virtual environment with the compiler dependencies

$PYTHON -m venv "$MODEST_DIR/venv"
"$MODEST_DIR/venv/bin/python" -m pip install -r "$MODEST_DIR/requirements.txt"


for f in "$HOME/.bashrc" "$HOME/.zshrc"; do
	write_env_block "$f"
	echo "environment: $f"
done

echo ""
echo "Done. Restart your terminal to pick up the environment variables."
