# Installation

0. **Firstly you need to install Python3 & Clang** *(Clang optionally)*

1. Download the repository into your home (or another) folder:
```
cd ~
git clone https://github.com/lexbalan/Modest.git
```

2. Add environment variables:
```
export MODEST_DIR=~/Modest
export PATH=$PATH:$MODEST_DIR
export MODEST_LIB=$MODEST_DIR/lib/

echo "export MODEST_DIR=~/Modest" >> ~/.bashrc
echo "export PATH=$PATH:$MODEST_DIR" >> ~/.bashrc
echo "export MODEST_LIB=$MODEST_DIR/lib/" >> ~/.bashrc
```

> Restart your terminal after commands showed above

3. Compile example:
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


4. Run result:
```
./a.out
```
