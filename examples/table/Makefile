
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/table -funsafe -mbackend=cm $(INDIR)/table.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/table -mbackend=llvm -funsafe $(INDIR)/table.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/table.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/table -mbackend=c11 -funsafe $(INDIR)/table.m
	clang -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable $(CPREFIX)/main.c $(CPREFIX)/table.c


clean:
	rm *.o
