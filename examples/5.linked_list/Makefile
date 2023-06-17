
OUTDIR=./out
INDIR=./

# output dir prefix
CMPREFIX=$(OUTDIR)/cm/
CPREFIX=$(OUTDIR)/c/
LLVMPREFIX = $(OUTDIR)/llvm/

# mcc translator
MCC=mcc


all: LLVM


CM:
	$(MCC) -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.cm
	$(MCC) -o $(CMPREFIX)/linked_list -mbackend=cm $(INDIR)/linked_list.hm
	$(MCC) -o $(CMPREFIX)/linked_list -mbackend=cm $(INDIR)/linked_list.cm



LLVM:
  # 1. CM -> LLVM/IR
	$(MCC) -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.cm
	$(MCC) -o $(LLVMPREFIX)/linked_list -mbackend=llvm $(INDIR)/linked_list.cm
	
	# 2. LLVM/IR -> *.o
	clang -c $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/linked_list.ll
	
	# 3. *.o -> a.out
	CC main.o linked_list.o -o a.out



C:
	$(MCC) -o $(CPREFIX)/main -mbackend=c $(INDIR)/main.cm
	$(MCC) -o $(CPREFIX)/linked_list -mbackend=c $(INDIR)/linked_list.hm
	$(MCC) -o $(CPREFIX)/linked_list -mbackend=c $(INDIR)/linked_list.cm
	CC $(CPREFIX)/main.c $(CPREFIX)/linked_list.c


clean:
	rm *.o

