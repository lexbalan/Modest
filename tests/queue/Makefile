
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	#mcc -o $(CMPREFIX)/mutex -mbackend=cm $(INDIR)/mutex.m
	mcc -o $(CMPREFIX)/queue -mbackend=cm $(INDIR)/queue.m
	mcc -o $(CMPREFIX)/queueWord8 -mbackend=cm $(INDIR)/queueWord8.m
	mcc -o $(CMPREFIX)/ringWord8 -mbackend=cm $(INDIR)/ringWord8.m
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/queue -mbackend=llvm $(INDIR)/queue.m
	mcc -o $(LLVMPREFIX)/queueWord8 -mbackend=llvm $(INDIR)/queueWord8.m
	mcc -o $(LLVMPREFIX)/ringWord8 -mbackend=llvm $(INDIR)/ringWord8.m
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/queue.ll $(LLVMPREFIX)/queueWord8.ll $(LLVMPREFIX)/ringWord8.ll


C:
	mcc -o $(CPREFIX)/queue -mbackend=c $(INDIR)/queue.m
	mcc -o $(CPREFIX)/queueWord8 -mbackend=c $(INDIR)/queueWord8.m
	mcc -o $(CPREFIX)/ringWord8 -mbackend=c $(INDIR)/ringWord8.m
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	#mcc -o $(CPREFIX)/mutex -mbackend=c $(INDIR)/mutex.m
	$(CC) $(CPREFIX)/main.c $(CPREFIX)/queue.c $(CPREFIX)/queueWord8.c $(CPREFIX)/ringWord8.c 


clean:
	rm *.o
