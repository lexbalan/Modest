
OUTDIR=./out
INDIR=./

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/

# mcc translator
MCC=mcc


all: LLVM


CM:
	$(MCC) -o $(CMPREFIX)main -mbackend=cm -funsafe $(INDIR)/main.cm


LLVM:
	$(MCC) -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.cm
	
	# translate IR to .o
	clang -c $(LLVMPREFIX)/main.ll
	
	# compile .o files to a.out
	CC main.o -o a.out


C:
	$(MCC) -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.cm
	CC $(CPREFIX)/main.c


