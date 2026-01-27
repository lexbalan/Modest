
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/crc32 -mbackend=cm -funsafe ${MODEST_LIB}/misc/crc32.m

LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/crc32 -mbackend=llvm -funsafe ${MODEST_LIB}/misc/crc32.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/crc32.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.m
	mcc -o $(CPREFIX)/crc32 -mbackend=c11 -funsafe ${MODEST_LIB}/misc/crc32.m
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/crc32.c


clean:
	rm *.o

