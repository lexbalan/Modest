
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


.PHONY: CM C LLVM test clean

all: CM C LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=modest -funsafe $(INDIR)/main.m
	mcc -o $(CMPREFIX)/aes256 -mbackend=modest -funsafe ${MODEST_LIB}/misc/aes256.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/aes256 -mbackend=llvm -funsafe ${MODEST_LIB}/misc/aes256.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/aes256.ll
	./a.out


C:
	mcc -o $(CPREFIX)/main -mbackend=c12 -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/aes256 -mbackend=c12 -funsafe ${MODEST_LIB}/misc/aes256.m
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/aes256.c
	./a.out


clean:
	rm *.o a.out


test:
	$(MAKE) CM
	$(MAKE) C && ./a.out
	$(MAKE) LLVM && ./a.out

