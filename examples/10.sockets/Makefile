


INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/client -mbackend=cm $(INDIR)/client.m
	mcc -o $(CMPREFIX)/server -mbackend=cm $(INDIR)/server.m


LLVM:
	mcc -o $(LLVMPREFIX)/client -funsafe -mbackend=llvm $(INDIR)/client.m
	mcc -o $(LLVMPREFIX)/server -funsafe -mbackend=llvm $(INDIR)/server.m
	clang -oclient $(LLVMPREFIX)/client.ll
	clang -oserver $(LLVMPREFIX)/server.ll


C:
	mcc -o $(CPREFIX)/client -funsafe -mbackend=c $(INDIR)/client.m
	mcc -o $(CPREFIX)/server -funsafe -mbackend=c $(INDIR)/server.m
	$(CC) -oclient $(CPREFIX)/client.c
	$(CC) -oserver $(CPREFIX)/server.c


clean:
	rm *.o

