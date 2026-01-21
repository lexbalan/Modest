cd 1.* && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd 3.* && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd 4.* && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd 5.* && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd 6.* && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd 7.* && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd 8.* && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
#cd 9.* && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd 10.* && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd asm && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd stmt_if && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd stmt_while && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. &&\
cd demo1 && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd bubble_sort && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. #&& \
cd web && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd sha256 && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd table && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. && \
cd annotations && printf "\nBUILD: $PWD\n" && make -j7 test && cd .. \

#cd m328p_blink && printf "\nBUILD: $PWD\n" && make -j7 test && cd ..

