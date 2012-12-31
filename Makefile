.PHONY: all clean distclean
all: download.pdf
clean:
	rm -f *.sty
distclean: clean

%.pdf:
	pdflatex $*.tex
	makeglossaries $*
	biber $*
	pdflatex $*.tex
	makeglossaries $*
	pdflatex $*.tex

%.sty: $*.pdf
