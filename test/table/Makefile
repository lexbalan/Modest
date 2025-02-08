
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/table -funsafe -mbackend=cm $(INDIR)/table.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/table -mbackend=llvm -funsafe $(INDIR)/table.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/table.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/table -mbackend=c -funsafe $(INDIR)/table.m
	CC $(CPREFIX)/main.c $(CPREFIX)/table.c


clean:
	rm *.o
