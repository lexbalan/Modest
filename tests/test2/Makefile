
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/datetime -mbackend=cm -funsafe ${MODEST_LIB}/lightfood/datetime.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/datetime -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/datetime.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/datetime.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/datetime $(C_OPTIONS) -mbackend=c11 -funsafe ${MODEST_LIB}/lightfood/datetime.m
	clang -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable $(CPREFIX)/main.c $(CPREFIX)/datetime.c


clean:
	rm *.o
