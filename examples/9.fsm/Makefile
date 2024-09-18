
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
	mcc -o $(CMPREFIX)/ff -mbackend=cm ${MODEST_LIB}/lightfood/delay.m
	mcc -o $(CMPREFIX)/fsm -mbackend=cm $(INDIR)/fsm.m
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/utf $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/misc/utf.m
	
	mcc -o $(LLVMPREFIX)/putchar $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/putchar.m
	
	mcc -o $(LLVMPREFIX)/ff_delay -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/delay.m
	mcc -o $(LLVMPREFIX)/fsm -mbackend=llvm $(INDIR)/fsm.m
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m 
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/fsm.ll $(LLVMPREFIX)/ff_delay.ll $(LLVMPREFIX)/putchar.ll $(LLVMPREFIX)/utf.ll


C:
	mcc -o $(CPREFIX)/utf $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/utf.m
	mcc -o $(CPREFIX)/putchar $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/putchar.m
	
	mcc -o $(CPREFIX)/ff_delay -mbackend=c $(C_OPTIONS) ${MODEST_LIB}/lightfood/delay.m
	mcc -o $(CPREFIX)/fsm -mbackend=c $(C_OPTIONS) $(INDIR)/fsm.m
	mcc -o $(CPREFIX)/main -mbackend=c $(C_OPTIONS) $(INDIR)/main.m
    
	CC $(CPREFIX)/main.c $(CPREFIX)/fsm.c $(CPREFIX)/ff_delay.c $(CPREFIX)/utf.c $(CPREFIX)/putchar.c
	
	#mcc -o $(CPREFIX)/print -mbackend=c $(C_OPTIONS) -funsafe ${MODEST_LIB}/lightfood/print.m
	#$(CPREFIX)/print.c 


clean:
	rm *.o
