
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	mcc -funsafe -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m
	mcc -funsafe -o $(CMPREFIX)/fixed32 -mbackend=cm $(INDIR)/fixed32.m
	mcc -funsafe -o $(CMPREFIX)/fixed64 -mbackend=cm $(INDIR)/fixed64.m


LLVM:
	mcc -funsafe -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	mcc -funsafe -o $(LLVMPREFIX)/fixed32 -mbackend=llvm $(INDIR)/fixed32.m
	mcc -funsafe -o $(LLVMPREFIX)/fixed64 -mbackend=llvm $(INDIR)/fixed64.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/fixed32.ll $(LLVMPREFIX)/fixed64.ll


C:
	mcc -funsafe -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.m
	mcc -funsafe -o $(CPREFIX)/fixed32 -mbackend=c11 $(INDIR)/fixed32.m
	mcc -funsafe -o $(CPREFIX)/fixed64 -mbackend=c11 $(INDIR)/fixed64.m
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/fixed32.c $(CPREFIX)/fixed64.c


clean:
	rm *.o

