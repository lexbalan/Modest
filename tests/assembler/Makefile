
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -funsafe -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m


LLVM:
	mcc -funsafe -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	clang $(LLVMPREFIX)/main.ll


C:
	mcc -funsafe -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.m
	clang $(C_OPTIONS) $(CPREFIX)/main.c


clean:
	rm *.o
