


INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/client -mbackend=modest $(INDIR)/client.m
	mcc -o $(CMPREFIX)/server -mbackend=modest $(INDIR)/server.m


LLVM:
	mcc -o $(LLVMPREFIX)/client -funsafe -mbackend=llvm $(INDIR)/client.m
	mcc -o $(LLVMPREFIX)/server -funsafe -mbackend=llvm $(INDIR)/server.m
	clang -oclient $(LLVMPREFIX)/client.ll
	clang -oserver $(LLVMPREFIX)/server.ll


C:
	mcc -o $(CPREFIX)/client -funsafe -mbackend=c12 $(INDIR)/client.m
	mcc -o $(CPREFIX)/server -funsafe -mbackend=c12 $(INDIR)/server.m
	clang $(C_OPTIONS) -oclient $(CPREFIX)/client.c
	clang $(C_OPTIONS) -oserver $(CPREFIX)/server.c


clean:
	rm *.o

