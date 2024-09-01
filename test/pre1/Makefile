
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/sub -mbackend=cm $(INDIR)/sub.m
	#mcc -o $(CMPREFIX)/sub2 -mbackend=cm $(INDIR)/sub2.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/sub -mbackend=llvm $(INDIR)/sub.m
	#mcc -o $(LLVMPREFIX)/sub2 -mbackend=llvm $(INDIR)/sub2.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/sub.ll #$(LLVMPREFIX)/sub2.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.m
	mcc -o $(CPREFIX)/sub -mbackend=c $(INDIR)/sub.m
	mcc -o $(CPREFIX)/console -mbackend=c $(INDIR)/console.m
	CC $(CPREFIX)/main.c $(CPREFIX)/sub.c


clean:
	rm *.o
