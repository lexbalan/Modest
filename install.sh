#!/bin/sh

CUR_DIR=$PWD

./configure.sh

echo "" >> ~/.zshrc
echo "export MODEST_DIR=$CUR_DIR" >> ~/.zshrc
echo "export PATH=\$PATH:\$MODEST_DIR" >> ~/.zshrc
echo "export MODEST_LIB=\$MODEST_DIR/lib/" >> ~/.zshrc

echo "" >> ~/.bashrc
echo "export MODEST_DIR=$CUR_DIR" >> ~/.bashrc
echo "export PATH=\$PATH:\$MODEST_DIR" >> ~/.bashrc
echo "export MODEST_LIB=\$MODEST_DIR/lib/" >> ~/.bashrc

