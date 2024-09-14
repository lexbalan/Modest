
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	clang $(LLVMPREFIX)/main.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.m
	mcc -o $(CPREFIX)/crc32 $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/crc32.m
	CC $(CPREFIX)/main.c $(CPREFIX)/crc32.c


clean:
	rm *.o
