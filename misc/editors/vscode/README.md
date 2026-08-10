# Modest Language for VS Code

Syntax highlighting for the [Modest programming language](https://github.com/lexbalan/Modest).

## Features

- Syntax highlighting: keywords, types, functions, strings, numbers, comments
- Attributes (`@layout`, `@branded`, ...), directives (`$if`, ...) and tags (`#tag`)
- Bracket matching, auto-closing pairs, comment toggling (`Cmd+/`)

## Installation (local, from source)

Quit VS Code first: it rewrites `extensions.json` itself, and a copy running
during the install can put back the version it started with.

macOS, Linux:

```sh
./install.sh
```

Windows:

```bat
install.bat
```

The script links this folder into the VS Code extensions directory (both
stable and Insiders, whichever is present), replacing an earlier install of
the extension if it finds one. Since it is a link and not a copy, `git pull`
is enough to update the extension afterwards.

It then registers the extension in `extensions.json` next to the link, by
calling `register.py` — the same script on both platforms. Since VS Code 1.74
that file, and not the directory listing, is what the extension scanner
reads: a folder missing from it is ignored however valid its `package.json`
is, and the extension never shows up — not in the Extensions view, not in
`code --list-extensions`, and `.m` files stay unhighlighted. An earlier entry
for the same id is replaced, and a `.bak` of the file is kept.

Start VS Code again and check that it took:

```sh
code --list-extensions | grep modest
```

To uninstall, delete the linked folder and drop its entry from the registry:

```sh
rm ~/.vscode/extensions/lexbalan.modest-lang-0.1.0
python3 -c "import json,sys; p=sys.argv[1]; d=json.load(open(p)); \
json.dump([e for e in d if e['identifier']['id']!='lexbalan.modest-lang'], \
open(p,'w'), separators=(',',':'))" ~/.vscode/extensions/extensions.json
```

## Note on the `.m` extension

Objective-C, which is built into VS Code, claims `.m` as well, and being
built in it usually wins; MATLAB claims it too. Expect to need this in your
settings (workspace or user):

```json
"files.associations": {
	"*.m": "modest"
}
```

## Packaging for the Marketplace

```sh
npm install -g @vscode/vsce
vsce package        # produces modest-lang-0.1.0.vsix
```

The `.vsix` can be installed via "Extensions: Install from VSIX..." or
published with `vsce publish` (requires a Marketplace publisher account).
