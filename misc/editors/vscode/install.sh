#!/bin/sh
set -e

EXT_SRC=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

PYTHON=python3


# The installed folder is named after package.json rather than hardcoded,
# so that a version bump here does not silently leave the old entry behind.

read_field() {
	sed -n 's/^[[:space:]]*"'"$1"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
		"$EXT_SRC/package.json" | head -n 1
}

PUBLISHER=$(read_field publisher)
NAME=$(read_field name)
VERSION=$(read_field version)

if [ -z "$PUBLISHER" ] || [ -z "$NAME" ] || [ -z "$VERSION" ]; then
	echo "install: cannot read publisher/name/version from package.json" 1>&2
	exit 1
fi

EXT_ID="$PUBLISHER.$NAME"

REGISTER_FAILED=0


# The extension is linked, not copied: the working copy stays the one in the
# repository, so a git pull is enough to update it.

install_into() {
	[ -d "$1" ] || return 1

	ext_dir="$1/extensions"
	mkdir -p "$ext_dir"

	# drop earlier installs of this extension, whatever version they carry
	for old in "$ext_dir/$EXT_ID"*; do
		if [ -e "$old" ] || [ -L "$old" ]; then
			rm -rf "$old"
		fi
	done

	ln -s "$EXT_SRC" "$ext_dir/$EXT_ID-$VERSION"
	echo "installed: $ext_dir/$EXT_ID-$VERSION"

	# Placing the folder is only half of it: since VS Code 1.74 the list of
	# user extensions is read from <ext-dir>/extensions.json, and a folder
	# missing from it is ignored however valid its package.json is.
	if ! $PYTHON "$EXT_SRC/register.py" \
			"$ext_dir" "$EXT_ID" "$VERSION" "$EXT_ID-$VERSION"; then
		echo "install: could not register the extension in" 1>&2
		echo "install:   $ext_dir/extensions.json" 1>&2
		echo "install: VS Code ignores folders that are not listed there." 1>&2
		REGISTER_FAILED=1
	fi
}


found=0

for d in "$HOME/.vscode" "$HOME/.vscode-insiders"; do
	if install_into "$d"; then
		found=$((found + 1))
	fi
done

if [ "$found" -eq 0 ]; then
	echo "install: no VS Code directory in $HOME (.vscode, .vscode-insiders)" 1>&2
	exit 1
fi

# Registration is the step that actually makes VS Code see the extension, so
# a failure there is a failure of the install, not a warning to scroll past.
if [ "$REGISTER_FAILED" -ne 0 ]; then
	exit 1
fi

echo ""
echo "Reload VS Code: Cmd/Ctrl+Shift+P -> \"Developer: Reload Window\"."
echo "If the extension still does not show up, quit VS Code and start it again."
echo ""
echo "Objective-C and MATLAB also claim the .m extension. If your files open"
echo "as one of those, add to your VS Code settings.json:"
echo "    \"files.associations\": {\"*.m\": \"modest\"}"
