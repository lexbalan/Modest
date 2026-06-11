# Modest Language for VS Code

Syntax highlighting for the [Modest programming language](https://github.com/lexbalan/Modest).

## Features

- Syntax highlighting: keywords, types, functions, strings, numbers, comments
- Attributes (`@layout`, `@branded`, ...), directives (`$if`, ...) and tags (`#tag`)
- Bracket matching, auto-closing pairs, comment toggling (`Cmd+/`)

## Installation (local, from source)

Symlink (or copy) this folder into your VS Code extensions directory:

```sh
ln -s "$(pwd)" ~/.vscode/extensions/lexbalan.modest-lang-0.1.0
```

Then reload VS Code (`Cmd+Shift+P` → "Developer: Reload Window").

## Note on the `.m` extension

Objective-C (built into VS Code) and MATLAB also use `.m`. If your files
open as Objective-C, add this to your settings (workspace or user):

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
