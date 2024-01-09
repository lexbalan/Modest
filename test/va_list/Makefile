
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.cm



LLVM:
	mcc -o $(LLVMPREFIX)/main -funsafe -mbackend=llvm $(INDIR)/main.cm
	
	mcc -o $(LLVMPREFIX)/print -funsafe -mbackend=llvm ${MODEST_LIB}/fastfood/print.cm

	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/print.ll


C:
	mcc -o $(CPREFIX)/main -funsafe -mbackend=c $(INDIR)/main.cm
	
	mcc -o $(CPREFIX)/print $(C_OPTIONS) -funsafe -mbackend=c ${MODEST_LIB}/fastfood/print.hm
	
	mcc -o $(CPREFIX)/print $(C_OPTIONS) -funsafe -mbackend=c ${MODEST_LIB}/fastfood/print.cm
	
	CC $(CPREFIX)/main.c $(CPREFIX)/print.c

clean:
	rm *.o
