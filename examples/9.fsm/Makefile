
OUTDIR=./out
INDIR=./src

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm

LIBPREFIX = ./lib

test: CM LLVM C


C_OPTIONS = -mstyle=legacy

CM:
	mcc -o $(CMPREFIX)/ff -mbackend=cm ${MODEST_LIB}/lightfood/delay.m
	mcc -o $(CMPREFIX)/fsm -mbackend=cm $(INDIR)/fsm.m
	mcc -o $(CMPREFIX)/main -mbackend=cm $(INDIR)/main.m


LLVM:
	mcc -o $(LLVMPREFIX)/utf $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/misc/utf.m
	
	mcc -o $(LLVMPREFIX)/console $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/console.m
	
	mcc -o $(LLVMPREFIX)/delay -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/delay.m
	mcc -o $(LLVMPREFIX)/fsm -mbackend=llvm $(INDIR)/fsm.m
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm $(INDIR)/main.m 
	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/fsm.ll $(LLVMPREFIX)/delay.ll $(LLVMPREFIX)/console.ll $(LLVMPREFIX)/utf.ll


C:
	mcc -o $(CPREFIX)/utf $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/utf.m
	mcc -o $(CPREFIX)/console $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/console.m
	
	mcc -o $(CPREFIX)/delay -mbackend=c $(C_OPTIONS) ${MODEST_LIB}/lightfood/delay.m
	mcc -o $(CPREFIX)/fsm -mbackend=c $(C_OPTIONS) $(INDIR)/fsm.m
	mcc -o $(CPREFIX)/main -mbackend=c $(C_OPTIONS) $(INDIR)/main.m
    
	clang -Wall -Wextra -pedantic -Wno-unused-variable $(CPREFIX)/main.c $(CPREFIX)/fsm.c $(CPREFIX)/delay.c $(CPREFIX)/utf.c $(CPREFIX)/console.c
	
	#mcc -o $(CPREFIX)/print -mbackend=c $(C_OPTIONS) -funsafe ${MODEST_LIB}/lightfood/print.m
	#$(CPREFIX)/print.c 


clean:
	rm *.o
