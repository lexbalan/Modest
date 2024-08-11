
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.cm
	mcc -o $(CMPREFIX)/sub -mbackend=cm $(INDIR)/sub.cm
	mcc -o $(CMPREFIX)/sub2 -mbackend=cm $(INDIR)/sub2.cm


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.cm
	mcc -o $(LLVMPREFIX)/sub -mbackend=llvm $(INDIR)/sub.cm
	mcc -o $(LLVMPREFIX)/sub2 -mbackend=llvm $(INDIR)/sub2.cm
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/sub.ll $(LLVMPREFIX)/sub2.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.cm
	mcc -o $(CPREFIX)/sub -fheader -mbackend=c $(INDIR)/sub.cm
	mcc -o $(CPREFIX)/sub2 -fheader -mbackend=c $(INDIR)/sub2.cm
	mcc -o $(CPREFIX)/console -fheader -mbackend=c $(INDIR)/console.cm
	CC $(CPREFIX)/main.c 


clean:
	rm *.o
