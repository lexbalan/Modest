
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
	mcc -o $(CMPREFIX)/byteQueue -mbackend=cm $(INDIR)/byteQueue.m
	mcc -o $(CMPREFIX)/byteRing -mbackend=cm $(INDIR)/byteRing.m
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/queue -mbackend=llvm $(INDIR)/queue.m
	mcc -o $(LLVMPREFIX)/byteQueue -mbackend=llvm $(INDIR)/byteQueue.m
	mcc -o $(LLVMPREFIX)/byteRing -mbackend=llvm $(INDIR)/byteRing.m
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/queue.ll $(LLVMPREFIX)/byteQueue.ll $(LLVMPREFIX)/byteRing.ll


C:
	mcc -o $(CPREFIX)/queue -mbackend=c $(INDIR)/queue.m
	mcc -o $(CPREFIX)/byteQueue -mbackend=c $(INDIR)/byteQueue.m
	mcc -o $(CPREFIX)/byteRing -mbackend=c $(INDIR)/byteRing.m
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	#mcc -o $(CPREFIX)/mutex -mbackend=c $(INDIR)/mutex.m
	CC $(CPREFIX)/main.c $(CPREFIX)/queue.c $(CPREFIX)/byteQueue.c $(CPREFIX)/byteRing.c 


clean:
	rm *.o
