
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
	clang $(LLVMPREFIX)/main.ll


C:
	mcc -funsafe -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.m
	mcc -funsafe -o $(CPREFIX)/fixed32 -mbackend=c $(INDIR)/fixed32.m
	mcc -funsafe -o $(CPREFIX)/fixed64 -mbackend=c $(INDIR)/fixed64.m
	$(CC) $(CPREFIX)/main.c $(CPREFIX)/fixed32.c $(CPREFIX)/fixed64.c


clean:
	rm *.o
