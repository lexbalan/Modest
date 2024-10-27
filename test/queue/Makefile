
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	#mcc -o $(CMPREFIX)/mutex -mbackend=cm $(INDIR)/mutex.m
	mcc -o $(CMPREFIX)/queue -mbackend=cm $(INDIR)/queue.m
	mcc -o $(CMPREFIX)/byteQueue128 -mbackend=cm $(INDIR)/byteQueue128.m
	mcc -o $(CMPREFIX)/byteRing16 -mbackend=cm $(INDIR)/byteRing16.m
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/queue -mbackend=llvm $(INDIR)/queue.m
	mcc -o $(LLVMPREFIX)/byteQueue128 -mbackend=llvm $(INDIR)/byteQueue128.m
	mcc -o $(LLVMPREFIX)/byteRing16 -mbackend=llvm $(INDIR)/byteRing16.m
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/queue.ll $(LLVMPREFIX)/byteQueue128.ll $(LLVMPREFIX)/byteRing16.ll


C:
	mcc -o $(CPREFIX)/queue -mbackend=c $(INDIR)/queue.m
	mcc -o $(CPREFIX)/byteQueue128 -mbackend=c $(INDIR)/byteQueue128.m
	mcc -o $(CPREFIX)/byteRing16 -mbackend=c $(INDIR)/byteRing16.m
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	#mcc -o $(CPREFIX)/mutex -mbackend=c $(INDIR)/mutex.m
	CC $(CPREFIX)/main.c $(CPREFIX)/queue.c $(CPREFIX)/byteQueue128.c $(CPREFIX)/byteRing16.c 


clean:
	rm *.o
