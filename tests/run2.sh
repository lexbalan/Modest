

cd crc32 && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd chacha20 && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd sha256 && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd aes256 && printf "\nBUILD: $PWD\n" && make -j7 test && cd ..
