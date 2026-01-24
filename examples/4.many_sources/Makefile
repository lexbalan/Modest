
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m
	mcc -o $(CMPREFIX)/lib -mbackend=cm $(INDIR)/lib.m
  

LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/lib -mbackend=llvm $(INDIR)/lib.m
	
	# translate IR to .o
	clang -c $(LLVMPREFIX)/main.ll
	clang -c $(LLVMPREFIX)/lib.ll
	
	# compile .o files to a.out
	clang -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable main.o lib.o -o a.out


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.m
	mcc -o $(CPREFIX)/lib -mbackend=c11 $(INDIR)/lib.m
	clang -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable $(CPREFIX)/main.c $(CPREFIX)/lib.c


clean:
	rm *.o

