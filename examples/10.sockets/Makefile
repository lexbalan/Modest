


INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


all: LLVM


CM:
	mcc -o $(CMPREFIX)/client -mbackend=cm $(INDIR)/client.cm
	mcc -o $(CMPREFIX)/server -mbackend=cm $(INDIR)/server.cm


LLVM:
	mcc -o $(LLVMPREFIX)/client -funsafe -mbackend=llvm $(INDIR)/client.cm
	mcc -o $(LLVMPREFIX)/server -funsafe -mbackend=llvm $(INDIR)/server.cm
	clang -oclient $(LLVMPREFIX)/client.ll
	clang -oserver $(LLVMPREFIX)/server.ll


C:
	mcc -o $(CPREFIX)/client -funsafe -mbackend=c $(INDIR)/client.cm
	mcc -o $(CPREFIX)/server -funsafe -mbackend=c $(INDIR)/server.cm
	CC -oclient $(CPREFIX)/client.c
	CC -oserver $(CPREFIX)/server.c


clean:
	rm *.o

