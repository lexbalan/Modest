
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


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/console -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/console.m
	mcc -o $(LLVMPREFIX)/utf -mbackend=llvm -funsafe ${MODEST_LIB}/misc/utf.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/utf.ll $(LLVMPREFIX)/console.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.m
	mcc -o $(CPREFIX)/console -mbackend=c11 -funsafe ${MODEST_LIB}/lightfood/console.m
	mcc -o $(CPREFIX)/utf -mbackend=c11 -funsafe ${MODEST_LIB}/misc/utf.m

	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/console.c $(CPREFIX)/utf.c


clean:
	rm *.o
