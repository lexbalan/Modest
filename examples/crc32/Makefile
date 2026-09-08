
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


.PHONY: CM C LLVM test clean


all: CM LLVM C


CM:
	modest -o $(CMPREFIX)/main -mbackend=modest $(INDIR)/main.modest
	modest -o $(CMPREFIX)/crc32 -mbackend=modest -funsafe ${MODEST_LIB}/misc/crc32.modest

LLVM:
	modest -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.modest
	modest -o $(LLVMPREFIX)/crc32 -mbackend=llvm -funsafe ${MODEST_LIB}/misc/crc32.modest
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/crc32.ll
	./a.out

C:
	modest -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.modest
	modest -o $(CPREFIX)/crc32 -mbackend=c11 -funsafe ${MODEST_LIB}/misc/crc32.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/crc32.c
	./a.out


clean:
	rm *.o a.out


test:
	$(MAKE) CM
	$(MAKE) C && ./a.out
	$(MAKE) LLVM && ./a.out

