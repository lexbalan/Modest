
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	modest -o $(CMPREFIX)/main -mbackend=modest $(INDIR)/main.modest
	modest -o $(CMPREFIX)/lib -mbackend=modest $(INDIR)/lib.modest


LLVM:
	modest -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.modest
	modest -o $(LLVMPREFIX)/lib -mbackend=llvm $(INDIR)/lib.modest

	# translate IR to .o
	clang -c $(LLVMPREFIX)/main.ll
	clang -c $(LLVMPREFIX)/lib.ll

	# compile .o files to a.out
	clang $(C_OPTIONS) main.o lib.o -o a.out


C:
	modest -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.modest
	modest -o $(CPREFIX)/lib -mbackend=c11 $(INDIR)/lib.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/lib.c


clean:
	rm *.o

