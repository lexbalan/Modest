
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe $(INDIR)/main.cm


LLVM:
	mcc -o $(LLVMPREFIX)/sha256 $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/misc/sha256.cm

	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.cm
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/sha256.ll


C:
	mcc -o $(CPREFIX)/sha256 $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/sha256.hm
	mcc -o $(CPREFIX)/sha256 $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/sha256.cm
	
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.cm
	CC $(CPREFIX)/main.c $(CPREFIX)/sha256.c


clean:
	rm *.o
