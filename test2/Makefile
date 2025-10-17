
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -funsafe -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/lib -funsafe -mbackend=cm $(INDIR)/lib.m
	mcc -o $(CMPREFIX)/lib2 -funsafe -mbackend=cm $(INDIR)/lib2.m
	mcc -o $(CMPREFIX)/fixed32 -funsafe -mbackend=cm $(INDIR)/fixed32.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/lib -mbackend=llvm -funsafe $(INDIR)/lib.m
	mcc -o $(LLVMPREFIX)/lib2 -mbackend=llvm -funsafe $(INDIR)/lib2.m
	mcc -o $(LLVMPREFIX)/fixed32 -mbackend=llvm -funsafe $(INDIR)/fixed32.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/lib.ll $(LLVMPREFIX)/fixed32.ll


C:
	mcc -o $(CPREFIX)/main --config=config.toml -mbackend=c -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/lib --config=config.toml -mbackend=c -funsafe $(INDIR)/lib.m
	mcc -o $(CPREFIX)/lib2 --config=config.toml -mbackend=c -funsafe $(INDIR)/lib2.m
	mcc -o $(CPREFIX)/fixed32 --config=config.toml -mbackend=c -funsafe $(INDIR)/fixed32.m
	$(CC) $(CPREFIX)/main.c $(CPREFIX)/lib.c $(CPREFIX)/fixed32.c


clean:
	rm *.o
