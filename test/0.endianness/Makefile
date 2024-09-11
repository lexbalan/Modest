
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -funsafe -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m


LLVM:
	mcc -funsafe -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	#mcc -o $(LLVMPREFIX)/memory -funsafe -mbackend=llvm ${MODEST_LIB}/lightfood/memory.m
	clang $(LLVMPREFIX)/main.ll


C:
	mcc -funsafe -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.m
	CC $(CPREFIX)/main.c


clean:
	rm *.o
