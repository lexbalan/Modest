
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
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/print -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/print.m
	mcc -o $(LLVMPREFIX)/utf $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/misc/utf.m	
	mcc -o $(LLVMPREFIX)/putchar $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/putchar.m

	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/print.ll $(LLVMPREFIX)/putchar.ll $(LLVMPREFIX)/utf.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/utf $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/utf.m
	mcc -o $(CPREFIX)/putchar $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/putchar.m
	mcc -o $(CPREFIX)/print $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/print.m
	
	CC $(CPREFIX)/main.c $(CPREFIX)/print.c $(CPREFIX)/utf.c $(CPREFIX)/putchar.c

clean:
	rm *.o
