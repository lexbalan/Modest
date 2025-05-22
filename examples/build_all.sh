cd 1.* && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 3.* && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 4.* && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 5.* && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 6.* && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 7.* && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 8.* && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 9.* && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd 10.* && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd stmt_if && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd stmt_while && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. &&\
cd demo1 && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. && \
cd bubble_sort && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. #&& \
cd web && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd .. #&& \
#cd m328p_blink && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd ..
cd sha256 && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd ..
cd table && echo -c "\nBUILD:" "$PWD" && make -j7 && make -j7 C && make -j7 CM && cd ..

