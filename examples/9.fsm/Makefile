
OUTDIR=./out
INDIR=./src

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter

LIBPREFIX = ./lib

test: CM LLVM C


CM:
	modest -o $(CMPREFIX)/fsm -mbackend=modest $(INDIR)/fsm.modest
	modest -o $(CMPREFIX)/main -mbackend=modest $(INDIR)/main.modest


LLVM:
	modest -o $(LLVMPREFIX)/fsm -mbackend=llvm $(INDIR)/fsm.modest
	modest -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.modest
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/fsm.ll


C:
	modest -o $(CPREFIX)/fsm -mbackend=c11 $(INDIR)/fsm.modest
	modest -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/fsm.c


clean:
	rm *.o

