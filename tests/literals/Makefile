
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


.PHONY: CM C LLVM test clean

all: CM C LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=modest $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	clang $(LLVMPREFIX)/main.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c12 $(INDIR)/main.m
	clang $(C_OPTIONS) $(CPREFIX)/main.c


clean:
	rm *.o a.out


test:
	$(MAKE) CM
	#$(MAKE) C && ./a.out
	$(MAKE) LLVM && ./a.out

