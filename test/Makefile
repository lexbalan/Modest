
INDIR=./src
OUTDIR=./out

.PHONY: CM LUA clean

all: CM LUA


CM:
	mcc -o $(OUTDIR)/cm/main -mbackend=cm $(INDIR)/main.m

LUA:
	mcc -o $(OUTDIR)/lua/main -mbackend=lua $(INDIR)/main.m

clean:
	rm *.o

