


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
	mcc -o $(CPREFIX)/client -funsafe -mbackend=c11 $(INDIR)/client.m
	mcc -o $(CPREFIX)/server -funsafe -mbackend=c11 $(INDIR)/server.m
	clang -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -oclient $(CPREFIX)/client.c
	clang -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -oserver $(CPREFIX)/server.c


clean:
	rm *.o

