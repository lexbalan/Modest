
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter

LIBS = -lm

test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/minmax -mbackend=llvm -funsafe ${MODEST_LIB}/misc/minmax.m
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m

	clang $(LIBS) $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/minmax.ll


C:
	mcc -o $(CPREFIX)/minmax -mbackend=c11 -funsafe ${MODEST_LIB}/misc/minmax.m
	mcc -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.m
	clang $(C_OPTIONS) $(LIBS) $(CPREFIX)/main.c $(CPREFIX)/minmax.c


clean:
	rm *.o
