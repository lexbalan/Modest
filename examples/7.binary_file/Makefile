
OUTDIR=./out
INDIR=./

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/


MCC_OPTIONS = -funsafe -mint=64

all: LLVM


CM:
	mcc $(MCC_OPTIONS) -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.cm


LLVM:
	mcc $(MCC_OPTIONS) -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.cm
	
	# translate IR to .o
	clang -c $(LLVMPREFIX)/main.ll
	
	# compile .o files to a.out
	CC main.o -o a.out


C:
	mcc $(MCC_OPTIONS) -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.cm
	CC $(CPREFIX)/main.c


clean:
	rm *.o

