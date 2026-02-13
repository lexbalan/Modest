
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter

test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=modest -funsafe $(INDIR)/main.m
	mcc -o $(CMPREFIX)/aes256 -mbackend=modest -funsafe ${MODEST_LIB}/misc/aes256.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/aes256 -mbackend=llvm -funsafe ${MODEST_LIB}/misc/aes256.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/aes256.ll
	./a.out


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/aes256 -mbackend=c11 -funsafe ${MODEST_LIB}/misc/aes256.m
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/aes256.c
	./a.out


clean:
	rm *.o

