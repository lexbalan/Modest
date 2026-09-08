
OUTDIR=./out
INDIR=./src

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	modest -o $(CMPREFIX)/main -mbackend=modest $(INDIR)/main.modest


LLVM:
	modest -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.modest
	clang $(LLVMPREFIX)/main.ll


C:
	modest -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c


clean:
	rm *.o

