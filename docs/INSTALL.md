# Installation

0. *Firstly install Python3 & Clang*

1. Download repository into your home folder
```
cd ~
git clone https://github.com/lexbalan/Modest.git
```

2. Add environment variables
```
export MODEST_DIR=~/Modest
export MODEST_LIB=$MODEST_DIR/lib/
```

3. Compile example
```
cd ~/Modest/examples/hello_world
make LLVM
```

4. Run result
```
./a.out
```
