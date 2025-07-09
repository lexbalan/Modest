
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


MCC_OPTIONS = -funsafe -mint=64

test: CM LLVM C


CM:
	mcc $(MCC_OPTIONS) -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m


LLVM:
	mcc $(MCC_OPTIONS) -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	clang $(LLVMPREFIX)/main.ll


C:
	mcc $(MCC_OPTIONS) -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.m
	$(CC) $(CPREFIX)/main.c


clean:
	rm *.o

