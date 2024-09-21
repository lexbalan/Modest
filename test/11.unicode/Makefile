
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/utf -mbackend=llvm -funsafe ${MODEST_LIB}/misc/utf.m
	mcc -o $(LLVMPREFIX)/console -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/console.m
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/console.ll $(LLVMPREFIX)/utf.ll


C:
	mcc -o $(CPREFIX)/utf $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/utf.m
	mcc -o $(CPREFIX)/console $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/console.m
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	
	CC $(CPREFIX)/main.c $(CPREFIX)/utf.c $(CPREFIX)/console.c
    


clean:
	rm *.o
