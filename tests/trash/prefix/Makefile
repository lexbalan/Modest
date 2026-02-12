
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	mcc -funsafe -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m
	mcc -funsafe -o $(CMPREFIX)/lib -mbackend=cm $(INDIR)/lib.m


LLVM:
	mcc -funsafe -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	mcc -funsafe -o $(LLVMPREFIX)/lib -mbackend=llvm $(INDIR)/lib.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/lib.ll


C:
	mcc -funsafe -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.m
	mcc -funsafe -o $(CPREFIX)/lib -mbackend=c11 $(INDIR)/lib.m
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/lib.c


clean:
	rm *.o
