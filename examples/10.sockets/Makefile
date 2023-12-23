


INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/


all: LLVM


CM:
	mcc -o $(CMPREFIX)/client -mbackend=cm $(INDIR)/client.cm
	mcc -o $(CMPREFIX)/server -mbackend=cm $(INDIR)/server.cm


LLVM:
	mcc -o $(LLVMPREFIX)/client -mbackend=llvm $(INDIR)/client.cm
	mcc -o $(LLVMPREFIX)/server -mbackend=llvm $(INDIR)/server.cm
	clang $(LLVMPREFIX)/client.ll
	clang $(LLVMPREFIX)/server.ll


C:
	mcc -o $(CPREFIX)/client -mbackend=c $(INDIR)/client.cm
	mcc -o $(CPREFIX)/server -mbackend=c $(INDIR)/server.cm
	CC $(CPREFIX)/client.c
	CC $(CPREFIX)/server.c


clean:
	rm *.o



all:
	mcc -o ./client -mbackend=c client.cm && gcc client.c -oclient
	mcc -o ./server -mbackend=c server.cm && gcc server.c -oserver

