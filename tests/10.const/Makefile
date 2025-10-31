
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm

LIBS = -lm

test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/minmax $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/misc/minmax.m
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	
	clang $(LIBS) $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/minmax.ll
    


C:
	mcc -o $(CPREFIX)/minmax $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/minmax.m
	mcc -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.m
	$(CC) $(LIBS) $(CPREFIX)/main.c $(CPREFIX)/minmax.c
	
	


clean:
	rm *.o
