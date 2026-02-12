
cd limits && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd structural_type_system && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd crc32 && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd chacha20 && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd sha256 && printf "\nBUILD: $PWD\n" && make -j7 test && cd ..

