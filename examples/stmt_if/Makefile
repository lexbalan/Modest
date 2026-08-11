
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=modest $(INDIR)/main.modest


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.modest
	clang $(LLVMPREFIX)/main.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c


clean:
	rm *.o

