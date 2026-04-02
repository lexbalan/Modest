
SRC=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=modest $(SRC)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(SRC)/main.m
	clang $(LLVMPREFIX)/main.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 $(SRC)/main.m
	mcc -o $(CPREFIX)/lib/lib -mbackend=c11 $(SRC)/lib/lib.m
	mcc -o $(CPREFIX)/lib/mod1 -mbackend=c11 $(SRC)/lib/mod1.m
	mcc -o $(CPREFIX)/lib/mod2 -mbackend=c11 $(SRC)/lib/mod2.m
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/lib/lib.c $(CPREFIX)/lib/mod1.c $(CPREFIX)/lib/mod2.c


clean:
	rm *.o

