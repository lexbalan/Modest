
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=modest $(INDIR)/main.m
	mcc -o $(CMPREFIX)/chacha20 -mbackend=modest ${MODEST_LIB}/misc/chacha20.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	mcc -o $(LLVMPREFIX)/chacha20 -mbackend=llvm ${MODEST_LIB}/misc/chacha20.m
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/chacha20.ll
	./a.out


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.m
	mcc -o $(CPREFIX)/chacha20 -mbackend=c11 ${MODEST_LIB}/misc/chacha20.m
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/chacha20.c
	./a.out


clean:
	rm *.o

