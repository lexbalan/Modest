
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/crc32 -mbackend=cm -funsafe ${MODEST_LIB}/misc/crc32.m

LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/crc32 -mbackend=llvm -funsafe ${MODEST_LIB}/misc/crc32.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/crc32.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.m
	mcc -o $(CPREFIX)/crc32 $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/crc32.m
	clang -Wall -Wextra -pedantic -Wno-unused-variable $(CPREFIX)/main.c $(CPREFIX)/crc32.c


clean:
	rm *.o
