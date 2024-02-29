# Installation

0. **Firstly you need to install Python3.11 & Clang** *(Clang optionally)*

1. Download the repository into your home (or another) folder:

```
cd ~
git clone https://github.com/lexbalan/Modest.git
```

2. Set environment variables:

```
export MODEST_DIR=~/Modest
export PATH=$PATH:$MODEST_DIR
export MODEST_LIB=$MODEST_DIR/lib/
```

You can add this variables to your shell rc file
```
# for BASH
echo "export MODEST_DIR=~/Modest" >> ~/.bashrc
echo "export PATH=$PATH:$MODEST_DIR" >> ~/.bashrc
echo "export MODEST_LIB=$MODEST_DIR/lib/" >> ~/.bashrc
# Restart your terminal after...

# for ZSH
echo "export MODEST_DIR=~/Modest" >> ~/.zshrc
echo "export PATH=$PATH:$MODEST_DIR" >> ~/.zshrc
echo "export MODEST_LIB=$MODEST_DIR/lib/" >> ~/.zshrc
# Restart your terminal after...
```

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
