
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe $(INDIR)/main.m
	#mcc -o $(CMPREFIX)/utf -mbackend=cm -funsafe ${MODEST_LIB}/misc/utf.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/console -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/console.m
	mcc -o $(LLVMPREFIX)/utf -mbackend=llvm -funsafe ${MODEST_LIB}/misc/utf.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/console.ll $(LLVMPREFIX)/utf.ll


C:
	mcc -o $(CPREFIX)/console $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/console.m
	mcc -o $(CPREFIX)/utf $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/utf.m
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	clang -Wall -Wextra -pedantic -Wno-unused-variable $(CPREFIX)/main.c $(CPREFIX)/console.c $(CPREFIX)/utf.c


clean:
	rm *.o
