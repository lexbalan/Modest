
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m
	mcc -o $(CPREFIX)/memory -mbackend=llvm -funsafe ${MODEST_LIB}/misc/memory.m

LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/memory -mbackend=llvm -funsafe ${MODEST_LIB}/misc/memory.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/memory.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.m
	mcc -o $(CPREFIX)/memory -mbackend=llvm -funsafe ${MODEST_LIB}/misc/memory.m
	CC $(CPREFIX)/main.c $(CPREFIX)/memory.c


clean:
	rm *.o
