
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter -I$(CPREFIX)/ff15/source


test: CM LLVM C


CFILES = \
	$(CPREFIX)/main.c \
	$(CPREFIX)/sys.c \
	$(CPREFIX)/ff15/source/ff.c \
	$(CPREFIX)/ff15/source/diskio.c \
	$(CPREFIX)/ff15/source/ffsystem.c \
	$(CPREFIX)/ff15/source/ffunicode.c
#$(CPREFIX)/ff15/source/mmc_bb.c



CM:
	mcc -o $(CMPREFIX)/main -mbackend=modest $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m
	clang $(LLVMPREFIX)/main.ll


C:
	mcc -o $(CPREFIX)/main -mbackend=c11 $(INDIR)/main.m
	clang $(C_OPTIONS) $(CFILES)


clean:
	rm *.o

