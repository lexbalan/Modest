
OUTDIR=./out
INDIR=./src

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm

LIBPREFIX = ./lib

test: CM LLVM C


C_OPTIONS = -mstyle=legacy

CM:
	mcc -o $(CMPREFIX)/fsm -mbackend=cm $(INDIR)/fsm.m
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/fsm -mbackend=llvm $(INDIR)/fsm.m
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/fsm.ll


C:
	mcc -o $(CPREFIX)/fsm -mbackend=c $(C_OPTIONS) $(INDIR)/fsm.m
	mcc -o $(CPREFIX)/main -mbackend=c $(C_OPTIONS) $(INDIR)/main.m
	clang -Wall -Wextra -pedantic -Wno-unused-variable $(CPREFIX)/main.c $(CPREFIX)/fsm.c


clean:
	rm *.o
