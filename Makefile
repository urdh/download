TEXMFHOME ?= $(shell kpsewhich -var-value TEXMFHOME)
.PHONY: all clean distclean install
all: download.pdf
clean:
	rm -f *.sty
distclean: clean

%.pdf: %.tex
	pdflatex $<
	makeglossaries $*
	biber $*
	pdflatex $<
	makeglossaries $*
	pdflatex $<

%.sty: %.pdf

install: all
	install -m 0644 download.sty $(TEXMFHOME)/tex/latex/download/download.sty
	install -m 0644 download.pdf $(TEXMFHOME)/doc/latex/download/download.pdf
	install -m 0644 download.tex $(TEXMFHOME)/source/latex/download/download.tex
	install -m 0644 README $(TEXMFHOME)/doc/latex/download/README
	-mktexlsr
