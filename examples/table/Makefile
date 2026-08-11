
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=modest $(INDIR)/main.modest
	mcc -o $(CMPREFIX)/table -funsafe -mbackend=modest $(INDIR)/table.modest


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.modest
	mcc -o $(LLVMPREFIX)/table -mbackend=llvm -funsafe $(INDIR)/table.modest
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/table.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 -funsafe $(INDIR)/main.modest
	mcc -o $(CPREFIX)/table -mbackend=c11 -funsafe $(INDIR)/table.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/table.c


clean:
	rm *.o

