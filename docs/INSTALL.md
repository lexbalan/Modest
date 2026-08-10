# Installation

0. **Firstly you need to install Python3.11 & Clang** *(Clang optionally)*

1. Download the repository into your home (or another) folder:

```
cd ~
git clone https://github.com/lexbalan/Modest.git
```

2. Run the setup script.

```
# Unix
cd ~/Modest
./bootstrap.sh
```

```
:: Windows
cd %USERPROFILE%\Modest
bootstrap.bat
```

It creates the Python virtual environment, installs the dependencies and
sets the environment variables `MODEST_DIR`, `MODEST_LIB` and `PATH`.
**Restart your terminal afterwards** — the variables only reach new shells.

The script is safe to run again after `git pull`: it rewrites its own
block in your shell rc files instead of appending a second copy.


## Setting the variables by hand

If you would rather not let the script touch your shell configuration,
set these three variables yourself:

```
export MODEST_DIR=~/Modest
export MODEST_LIB=$MODEST_DIR/lib
export PATH=$PATH:$MODEST_DIR
```

To make them permanent, add the lines to `~/.bashrc` or `~/.zshrc`.
On Windows use `setx` (or *System Properties → Environment Variables*):

```
setx MODEST_DIR "%USERPROFILE%\Modest"
setx MODEST_LIB "%USERPROFILE%\Modest\lib"
```

and append `%MODEST_DIR%` to your user `PATH`.


## Check the installation

Compile some example for compiler check

```
cd ~/Modest/examples/hello_world
make
```

Default target is LLVM, but you can get C output
```
make C
```

Or Modest output
```
make CM
```


Run result

```
./a.out
```
