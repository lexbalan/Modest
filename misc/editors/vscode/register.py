#!/usr/bin/env python3

# Registers an extension folder in VS Code's extensions.json.
#
# Since VS Code 1.74 the list of user extensions is read from
# <ext-dir>/extensions.json. A folder that is not listed there is ignored by
# the scanner however valid its package.json is, so linking or copying the
# folder into place is not enough on its own.
#
# Shared by install.sh and install.bat: the registry is the same JSON on both
# platforms, and the project already requires Python for the compiler itself.

import json
import os
import re
import shutil
import sys
import time


def uri_path(ext_dir, folder):
	# VS Code stores the location as a file URI path, which on Windows carries
	# a leading slash and a lower-case drive letter: /c:/Users/.../extensions
	p = os.path.join(ext_dir, folder).replace('\\', '/')
	if re.match(r'^[A-Za-z]:', p):
		return '/' + p[0].lower() + p[1:]
	if not p.startswith('/'):
		return '/' + p
	return p


def main(argv):
	if len(argv) != 5:
		sys.stderr.write("usage: register.py <ext-dir> <id> <version> <folder>\n")
		return 2

	ext_dir, ext_id, version, folder = argv[1:]
	registry = os.path.join(ext_dir, 'extensions.json')

	entries = []
	if os.path.isfile(registry):
		with open(registry, encoding='utf-8') as f:
			raw = f.read()
		if raw.strip():
			entries = json.loads(raw)
			if not isinstance(entries, list):
				sys.stderr.write("register: %s is not a JSON array\n" % registry)
				return 1
		shutil.copyfile(registry, registry + '.bak')

	# an earlier entry for this id would shadow the new one, whatever version
	# it names, so drop it rather than appending a second one
	kept = [e for e in entries if e.get('identifier', {}).get('id') != ext_id]

	kept.append({
		'identifier': {'id': ext_id},
		'version': version,
		'location': {'$mid': 1, 'path': uri_path(ext_dir, folder), 'scheme': 'file'},
		'relativeLocation': folder,
		# source=vsix and pinned=true keep VS Code from looking this extension
		# up in the Marketplace, where it does not exist, and offering updates
		'metadata': {
			'isApplicationScoped': False,
			'isMachineScoped': False,
			'isBuiltin': False,
			'installedTimestamp': int(time.time() * 1000),
			'pinned': True,
			'source': 'vsix',
			'private': False,
			'isPreReleaseVersion': False,
			'hasPreReleaseVersion': False,
			'preRelease': False,
		},
	})

	# no BOM and no trailing newline: VS Code writes the file compressed and
	# reads it with a strict parser
	with open(registry, 'w', encoding='utf-8', newline='') as f:
		json.dump(kept, f, separators=(',', ':'))

	print("registered: %s in %s" % (ext_id, registry))
	return 0


if __name__ == '__main__':
	sys.exit(main(sys.argv))
