
OUTDIR=./out
INDIR=./src

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe -mint=64 $(INDIR)/main.cm
	mcc -o $(CMPREFIX)/linked_list -mbackend=cm -mint=64 $(INDIR)/linked_list.hm
	mcc -o $(CMPREFIX)/linked_list -mbackend=cm -mint=64 $(INDIR)/linked_list.cm



LLVM:
  # 1. CM -> LLVM/IR
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe -mint=64 $(INDIR)/main.cm
	mcc -o $(LLVMPREFIX)/linked_list -mbackend=llvm -mint=64 $(INDIR)/linked_list.cm
	
	# 2. LLVM/IR -> *.o
	#clang -c $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/linked_list.ll
	
	# 3. *.o -> a.out
	#CC main.o linked_list.o -o a.out
	
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/linked_list.ll



C:
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe -mint=64 $(INDIR)/main.cm
	mcc -o $(CPREFIX)/linked_list -mstyle=modern -mbackend=c -mint=64 $(INDIR)/linked_list.hm
	mcc -o $(CPREFIX)/linked_list -mbackend=c -mint=64 $(INDIR)/linked_list.cm
	CC $(CPREFIX)/main.c $(CPREFIX)/linked_list.c


clean:
	rm *.o

