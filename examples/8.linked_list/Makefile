
OUTDIR=./out
INDIR=./src

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe -mint=64 $(INDIR)/main.m
	mcc -o $(CMPREFIX)/list -mbackend=cm -mint=64 $(INDIR)/list.m


LLVM:
  # 1. CM -> LLVM/IR
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe -mint=64 $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/list -mbackend=llvm -mint=64 $(INDIR)/list.m
	
	# 2. LLVM/IR -> *.o
	#clang -c $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/linked_list.ll
	
	# 3. *.o -> a.out
	#clang -Wall -Wextra -pedantic -Wno-unused-variable main.o linked_list.o -o a.out
	
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/list.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe -mint=64 $(INDIR)/main.m
	mcc -o $(CPREFIX)/list -mbackend=c -mint=64 $(INDIR)/list.m
	
	clang -Wall -Wextra -pedantic -Wno-unused-variable $(CPREFIX)/main.c $(CPREFIX)/list.c


clean:
	rm *.o

