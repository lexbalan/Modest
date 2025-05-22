cd 1.* && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 3.* && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 4.* && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 5.* && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 6.* && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 7.* && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 8.* && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 9.* && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 10.* && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd stmt_if && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd stmt_while && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. &&\
cd demo1 && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd bubble_sort && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. #&& \
cd web && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. #&& \
#cd m328p_blink && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd ..
cd sha256 && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd ..
cd table && printf "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd ..

