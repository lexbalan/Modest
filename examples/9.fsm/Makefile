
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
	mcc -o $(CMPREFIX)/fsm -mbackend=modest $(INDIR)/fsm.modest
	mcc -o $(CMPREFIX)/main -mbackend=modest $(INDIR)/main.modest


LLVM:
	mcc -o $(LLVMPREFIX)/fsm -mbackend=llvm $(INDIR)/fsm.modest
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.modest
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/fsm.ll


C:
	mcc -o $(CPREFIX)/fsm -mbackend=c11 $(INDIR)/fsm.modest
	mcc -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/fsm.c


clean:
	rm *.o

