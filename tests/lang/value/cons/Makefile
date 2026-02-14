INDIR=./src
OUTDIR=./out
CMPREFIX=$(OUTDIR)/cm

test: CM

CM:
	mcc -o $(CMPREFIX)/main -mbackend=modest $(INDIR)/main.m

clean:
	rm -rf $(OUTDIR)
