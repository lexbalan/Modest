
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm

test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe $(INDIR)/main.m
	mcc -o $(CMPREFIX)/sha256 -mbackend=cm -funsafe ${MODEST_LIB}/misc/sha256.m


LLVM:
	mcc -o $(LLVMPREFIX)/sha256 -mbackend=llvm -funsafe ${MODEST_LIB}/misc/sha256.m

	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/sha256.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/sha256 -mbackend=c $(C_OPTIONS) -funsafe ${MODEST_LIB}/misc/sha256.m

	clang -Wall -Wextra -pedantic -Wno-unused-variable $(CPREFIX)/main.c $(CPREFIX)/sha256.c


clean:
	rm *.o
