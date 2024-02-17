
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe $(INDIR)/main.cm



LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.cm
	
	mcc -o $(LLVMPREFIX)/print -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/print.cm

	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/print.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.cm
	
	mcc -o $(CPREFIX)/print $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/print.hm
	
	mcc -o $(CPREFIX)/print $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/print.cm
	
	CC $(CPREFIX)/main.c $(CPREFIX)/print.c

clean:
	rm *.o
