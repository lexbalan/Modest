
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/lib -funsafe -mbackend=cm $(INDIR)/lib.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/lib -mbackend=llvm -funsafe $(INDIR)/lib.m
	clang $(LLVMPREFIX)/main.ll


C:
	mcc -o $(CPREFIX)/main --config=config.toml -mbackend=c -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/lib --config=config.toml -mbackend=c -funsafe $(INDIR)/lib.m
	$(CC) $(CPREFIX)/main.c


clean:
	rm *.o
