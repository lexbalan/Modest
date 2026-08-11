
OUTDIR=./out
INDIR=./src

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=modest -funsafe -mint=64 $(INDIR)/main.modest
	mcc -o $(CMPREFIX)/list -mbackend=modest -mint=64 $(INDIR)/list.modest


LLVM:
  # 1. CM -> LLVM/IR
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe -mint=64 $(INDIR)/main.modest
	mcc -o $(LLVMPREFIX)/list -mbackend=llvm -mint=64 $(INDIR)/list.modest

	# 2. LLVM/IR -> *.o
	#clang -c $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/linked_list.ll

	# 3. *.o -> a.out
	#clang $(C_OPTIONS) main.o linked_list.o -o a.out

	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/list.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 -funsafe -mint=64 $(INDIR)/main.modest
	mcc -o $(CPREFIX)/list -mbackend=c11 -mint=64 $(INDIR)/list.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/list.c


clean:
	rm *.o

