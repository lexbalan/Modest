
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
	mcc -o $(CMPREFIX)/ff -mbackend=cm -funsafe ${MODEST_LIB}/fastfood/main.cm
	mcc -o $(CMPREFIX)/ff -mbackend=cm ${MODEST_LIB}/fastfood/delay.hm
	mcc -o $(CMPREFIX)/ff -mbackend=cm ${MODEST_LIB}/fastfood/delay.cm
	mcc -o $(CMPREFIX)/fsm -mbackend=cm $(INDIR)/fsm.hm
	mcc -o $(CMPREFIX)/fsm -mbackend=cm $(INDIR)/fsm.cm
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.cm


LLVM:
	mcc -o $(LLVMPREFIX)/ff_main -mbackend=llvm -funsafe ${MODEST_LIB}/fastfood/main.cm
	mcc -o $(LLVMPREFIX)/ff_delay -mbackend=llvm -funsafe ${MODEST_LIB}/fastfood/delay.cm
	mcc -o $(LLVMPREFIX)/fsm -mbackend=llvm $(INDIR)/fsm.hm
	mcc -o $(LLVMPREFIX)/fsm -mbackend=llvm $(INDIR)/fsm.cm
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.cm 
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/fsm.ll $(LLVMPREFIX)/ff_main.ll $(LLVMPREFIX)/ff_delay.ll


C:
	mcc -o $(CPREFIX)/ff_main -mbackend=c $(C_OPTIONS) ${MODEST_LIB}/fastfood/main.hm
	mcc -o $(CPREFIX)/ff_main -mbackend=c $(C_OPTIONS) -funsafe ${MODEST_LIB}/fastfood/main.cm
	mcc -o $(CPREFIX)/ff_delay -mbackend=c $(C_OPTIONS) ${MODEST_LIB}/fastfood/delay.hm
	mcc -o $(CPREFIX)/ff_delay -mbackend=c $(C_OPTIONS) ${MODEST_LIB}/fastfood/delay.cm
	mcc -o $(CPREFIX)/print -mbackend=c $(C_OPTIONS) -funsafe ${MODEST_LIB}/fastfood/print.cm
	mcc -o $(CPREFIX)/fsm -mbackend=c $(C_OPTIONS) $(INDIR)/fsm.hm
	mcc -o $(CPREFIX)/fsm -mbackend=c $(C_OPTIONS) $(INDIR)/fsm.cm
	mcc -o $(CPREFIX)/main -mbackend=c $(C_OPTIONS) $(INDIR)/main.cm
    
	CC $(CPREFIX)/main.c $(CPREFIX)/fsm.c $(CPREFIX)/ff_main.c $(CPREFIX)/ff_delay.c $(CPREFIX)/print.c


clean:
	rm *.o
