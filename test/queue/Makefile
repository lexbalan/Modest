
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe $(INDIR)/main.m
	mcc -o $(CMPREFIX)/mutex -mbackend=cm $(INDIR)/mutex.m
	mcc -o $(CMPREFIX)/queue -mbackend=cm $(INDIR)/queue.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	#mcc -o $(LLVMPREFIX)/sub -mbackend=llvm $(INDIR)/sub.m
	#mcc -o $(LLVMPREFIX)/sub2 -mbackend=llvm $(INDIR)/sub2.m
	clang $(LLVMPREFIX)/main.ll #$(LLVMPREFIX)/sub.ll $(LLVMPREFIX)/sub2.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/mutex -mbackend=c $(INDIR)/mutex.m
	mcc -o $(CPREFIX)/queue -mbackend=c $(INDIR)/queue.m
	mcc -o $(CPREFIX)/console -mbackend=c $(INDIR)/console.m
	CC $(CPREFIX)/main.c $(CPREFIX)/mutex.c $(CPREFIX)/queue.c 


clean:
	rm *.o
