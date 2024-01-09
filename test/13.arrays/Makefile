
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.cm


LLVM:
	mcc -o $(LLVMPREFIX)/minmax $(C_OPTIONS) -funsafe -mbackend=llvm ${MODEST_LIB}/misc/minmax.cm

	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.cm
	
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/minmax.ll
    


C:
	mcc -o $(CPREFIX)/minmax $(C_OPTIONS) -funsafe -mbackend=c ${MODEST_LIB}/misc/minmax.hm
	mcc -o $(CPREFIX)/minmax $(C_OPTIONS) -funsafe -mbackend=c ${MODEST_LIB}/misc/minmax.cm
	mcc -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.cm
	CC $(CPREFIX)/main.c $(CPREFIX)/minmax.c
	
	


clean:
	rm *.o
