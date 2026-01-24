
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe $(INDIR)/main.m
	mcc -o $(CMPREFIX)/console -mbackend=cm -funsafe ${MODEST_LIB}/lightfood/console.m


LLVM:
	mcc -o $(LLVMPREFIX)/utf -mbackend=llvm -funsafe ${MODEST_LIB}/misc/utf.m
	mcc -o $(LLVMPREFIX)/console -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/console.m
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/console.ll $(LLVMPREFIX)/utf.ll


C:
	mcc -o $(CPREFIX)/utf -mbackend=c11 -funsafe ${MODEST_LIB}/misc/utf.m
	mcc -o $(CPREFIX)/console -mbackend=c11 -funsafe ${MODEST_LIB}/lightfood/console.m
	mcc -o $(CPREFIX)/main -mbackend=c11 -funsafe $(INDIR)/main.m
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/utf.c $(CPREFIX)/console.c

clean:
	rm *.o

