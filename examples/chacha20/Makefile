
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
	mcc -o $(CMPREFIX)/main -mbackend=modest $(INDIR)/main.modest
	mcc -o $(CMPREFIX)/chacha20 -mbackend=modest ${MODEST_LIB}/misc/chacha20.modest


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.modest
	mcc -o $(LLVMPREFIX)/chacha20 -mbackend=llvm ${MODEST_LIB}/misc/chacha20.modest
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/chacha20.ll
	./a.out


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.modest
	mcc -o $(CPREFIX)/chacha20 -mbackend=c11 ${MODEST_LIB}/misc/chacha20.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/chacha20.c
	./a.out


clean:
	rm *.o a.out


test:
	$(MAKE) CM
	$(MAKE) C && ./a.out
	$(MAKE) LLVM && ./a.out

