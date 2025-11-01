
INDIR=./src
OUTDIR=./out

# output dir prefix
CMPREFIX=$(OUTDIR)/cm
CPREFIX=$(OUTDIR)/c
LLVMPREFIX = $(OUTDIR)/llvm


test: CM LLVM C


CM:
	mcc -o $(CMPREFIX)/main -mbackend=cm -funsafe $(INDIR)/main.m



LLVM:
	mcc -o $(LLVMPREFIX)/main -mbackend=llvm -funsafe $(INDIR)/main.m
	#mcc -o $(LLVMPREFIX)/print -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/print.m
	mcc -o $(LLVMPREFIX)/utf $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/misc/utf.m	
	#mcc -o $(LLVMPREFIX)/console $(C_OPTIONS) -mbackend=llvm -funsafe ${MODEST_LIB}/lightfood/console.m

	clang $(LLVMPREFIX)/main.ll $(LLVMPREFIX)/utf.ll # $(LLVMPREFIX)/print.ll $(LLVMPREFIX)/console.ll 


C:
	mcc -o $(CPREFIX)/main -mbackend=c -funsafe $(INDIR)/main.m
	mcc -o $(CPREFIX)/utf $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/misc/utf.m
	#mcc -o $(CPREFIX)/console $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/console.m
	#mcc -o $(CPREFIX)/print $(C_OPTIONS) -mbackend=c -funsafe ${MODEST_LIB}/lightfood/print.m
	
	clang -Wall -Wextra -pedantic -Wno-unused-variable $(CPREFIX)/main.c $(CPREFIX)/utf.c # $(CPREFIX)/console.c $(CPREFIX)/print.c

clean:
	rm *.o
