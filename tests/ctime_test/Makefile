
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/datetime -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/datetime.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/datetime.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.m
	$(CC) $(CPREFIX)/main.c


clean:
	rm *.o
