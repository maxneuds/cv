TEXFILE = main.tex
OUTDIR = build

all:
	mkdir -p $(OUTDIR)
	latexmk -pdf -outdir=$(OUTDIR) $(TEXFILE)

clean:
	rm -rf $(OUTDIR)
