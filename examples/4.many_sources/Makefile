
OUTDIR=./out
INDIR=./

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.cm
	mcc -o $(CMPREFIX)/lib -mbackend=cm $(INDIR)/lib.hm
	mcc -o $(CMPREFIX)/lib -mbackend=cm $(INDIR)/lib.cm
  


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.cm
	mcc -o $(LLVMPREFIX)/lib -mbackend=llvm $(INDIR)/lib.cm
	
	# translate IR to .o
	clang -c $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/lib.ll
	
	# compile .o files to a.out
	CC main.o lib.o -o a.out


C:
	mcc -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.cm
	mcc -o $(CPREFIX)/lib -mbackend=c $(INDIR)/lib.hm
	mcc -o $(CPREFIX)/lib -mbackend=c $(INDIR)/lib.cm
	CC $(CPREFIX)/main.c $(CPREFIX)/lib.c


clean:
	rm *.o

