
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/type -funsafe -mbackend=cm $(INDIR)/type.m
	mcc -o $(CMPREFIX)/value -funsafe -mbackend=cm $(INDIR)/value.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/type -mbackend=llvm -funsafe $(INDIR)/type.m
	mcc -o $(LLVMPREFIX)/value -mbackend=llvm -funsafe $(INDIR)/value.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/type.ll $(LLVMPREFIX)/value.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/type -mbackend=c -funsafe $(INDIR)/type.m
	mcc -o $(CPREFIX)/value -mbackend=c -funsafe $(INDIR)/value.m
	$(CC) $(CPREFIX)/main.c $(CPREFIX)/type.c $(CPREFIX)/value.c


clean:
	rm *.o
