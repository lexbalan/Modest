
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm
C_OPTIONS = -std=c11 -Wall -Wextra -pedantic -Wno-unused-variable -Wno-unused-parameter


test: CM LLVM C


CM:
	modest -o $(CMPREFIX)/queue -mbackend=modest $(INDIR)/queue.modest
	modest -o $(CMPREFIX)/queueWord8 -mbackend=modest $(INDIR)/queueWord8.modest
	modest -o $(CMPREFIX)/ringWord8 -mbackend=modest $(INDIR)/ringWord8.modest
	modest -o $(CMPREFIX)/main -mbackend=modest -funsafe $(INDIR)/main.modest


LLVM:
	modest -o $(LLVMPREFIX)/queue -mbackend=llvm $(INDIR)/queue.modest
	modest -o $(LLVMPREFIX)/queueWord8 -mbackend=llvm $(INDIR)/queueWord8.modest
	modest -o $(LLVMPREFIX)/ringWord8 -mbackend=llvm $(INDIR)/ringWord8.modest
	modest -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.modest
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/queue.ll $(LLVMPREFIX)/queueWord8.ll $(LLVMPREFIX)/ringWord8.ll


C:
	modest -o $(CPREFIX)/queue -mbackend=c11 $(INDIR)/queue.modest
	modest -o $(CPREFIX)/queueWord8 -mbackend=c11 $(INDIR)/queueWord8.modest
	modest -o $(CPREFIX)/ringWord8 -mbackend=c11 $(INDIR)/ringWord8.modest
	modest -o $(CPREFIX)/main -mbackend=c11 -funsafe $(INDIR)/main.modest
	clang $(C_OPTIONS) $(CPREFIX)/main.c $(CPREFIX)/queue.c $(CPREFIX)/queueWord8.c $(CPREFIX)/ringWord8.c 


clean:
	rm *.o
