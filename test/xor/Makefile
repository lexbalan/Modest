
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.cm


LLVM:
	mcc -o $(LLVMPREFIX)/main -funsafe -mbackend=llvm $(INDIR)/main.cm
	clang $(LLVMPREFIX)/main.ll


C:	
	mcc -o $(CPREFIX)/main -funsafe -mbackend=c $(INDIR)/main.cm
	CC $(CPREFIX)/main.c #$(CPREFIX)/utf.c


clean:
	rm *.o
