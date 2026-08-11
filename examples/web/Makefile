
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=modest $(INDIR)/main.modest


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.modest
	clang $(LLVMPREFIX)/main.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 -funsafe $(INDIR)/main.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c


clean:
	rm *.o

