
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
	mcc -o $(CMPREFIX)/ff -mbackend=cm ${MODEST_LIB}/lightfood/delay.hm
	mcc -o $(CMPREFIX)/ff -mbackend=cm ${MODEST_LIB}/lightfood/delay.cm
	mcc -o $(CMPREFIX)/fsm -mbackend=cm $(INDIR)/fsm.hm
	mcc -o $(CMPREFIX)/fsm -mbackend=cm $(INDIR)/fsm.cm
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.cm


LLVM:
	mcc -o $(LLVMPREFIX)/utf $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/misc/utf.cm
	
	mcc -o $(LLVMPREFIX)/putchar $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/putchar.cm
	
	mcc -o $(LLVMPREFIX)/ff_delay -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/delay.cm
	mcc -o $(LLVMPREFIX)/fsm -mbackend=llvm $(INDIR)/fsm.hm
	mcc -o $(LLVMPREFIX)/fsm -mbackend=llvm $(INDIR)/fsm.cm
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.cm 
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/fsm.ll $(LLVMPREFIX)/ff_delay.ll $(LLVMPREFIX)/putchar.ll $(LLVMPREFIX)/utf.ll


C:
	mcc -o $(CPREFIX)/utf $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/utf.hm
	mcc -o $(CPREFIX)/utf $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/utf.cm
	
	mcc -o $(CPREFIX)/putchar $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/putchar.hm
	mcc -o $(CPREFIX)/putchar $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/putchar.cm
	
	mcc -o $(CPREFIX)/ff_delay -mbackend=c $(C_OPTIONS) ${MODEST_LIB}/lightfood/delay.hm
	mcc -o $(CPREFIX)/ff_delay -mbackend=c $(C_OPTIONS) ${MODEST_LIB}/lightfood/delay.cm
	mcc -o $(CPREFIX)/print -mbackend=c $(C_OPTIONS) -funsafe ${MODEST_LIB}/lightfood/print.cm
	mcc -o $(CPREFIX)/fsm -mbackend=c $(C_OPTIONS) $(INDIR)/fsm.hm
	mcc -o $(CPREFIX)/fsm -mbackend=c $(C_OPTIONS) $(INDIR)/fsm.cm
	mcc -o $(CPREFIX)/main -mbackend=c $(C_OPTIONS) $(INDIR)/main.cm
    
	CC $(CPREFIX)/main.c $(CPREFIX)/fsm.c $(CPREFIX)/ff_delay.c $(CPREFIX)/print.c $(CPREFIX)/utf.c $(CPREFIX)/putchar.c


clean:
	rm *.o
