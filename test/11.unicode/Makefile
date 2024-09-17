
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
	mcc -o $(LLVMPREFIX)/putchar -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/putchar.m
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/putchar.ll $(LLVMPREFIX)/utf.ll


C:
	mcc -o $(CPREFIX)/utf $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/utf.m
	mcc -o $(CPREFIX)/putchar $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/putchar.m
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	
	CC $(CPREFIX)/main.c $(CPREFIX)/utf.c $(CPREFIX)/putchar.c
    


clean:
	rm *.o
