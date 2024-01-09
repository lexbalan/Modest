
OUTDIR=./out
INDIR=./src

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm

LIBPREFIX = ./lib

all: LLVM


C_OPTIONS = -mstyle=legacy

CM:
	mcc -o $(CMPREFIX)/ff -mbackend=cm ${MODEST_LIB}/fastfood/main.hm
	mcc -o $(CMPREFIX)/ff -funsafe -mbackend=cm ${MODEST_LIB}/fastfood/main.cm
	mcc -o $(CMPREFIX)/fsm -mbackend=cm $(INDIR)/fsm.hm
	mcc -o $(CMPREFIX)/fsm -mbackend=cm $(INDIR)/fsm.cm
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.cm


LLVM:
	mcc -o $(LLVMPREFIX)/ff -funsafe -mbackend=llvm ${MODEST_LIB}/fastfood/main.cm
	mcc -o $(LLVMPREFIX)/fsm -mbackend=llvm $(INDIR)/fsm.hm
	mcc -o $(LLVMPREFIX)/fsm -mbackend=llvm $(INDIR)/fsm.cm
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.cm
  
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/fsm.ll $(LLVMPREFIX)/ff.ll


C:
	mcc -o $(CPREFIX)/ff $(C_OPTIONS) -mbackend=c ${MODEST_LIB}/fastfood/main.hm
	mcc -o $(CPREFIX)/ff $(C_OPTIONS) -funsafe -mbackend=c ${MODEST_LIB}/fastfood/main.cm
	mcc -o $(CPREFIX)/print $(C_OPTIONS) -funsafe -mbackend=c ${MODEST_LIB}/fastfood/print.cm
	mcc -o $(CPREFIX)/fsm $(C_OPTIONS) -mbackend=c $(INDIR)/fsm.hm
	mcc -o $(CPREFIX)/fsm $(C_OPTIONS) -mbackend=c $(INDIR)/fsm.cm
	mcc -o $(CPREFIX)/main $(C_OPTIONS) -mbackend=c $(INDIR)/main.cm
    
	CC $(CPREFIX)/main.c $(CPREFIX)/fsm.c $(CPREFIX)/ff.c $(CPREFIX)/print.c


clean:
	rm *.o
