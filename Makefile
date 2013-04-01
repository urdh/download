.PHONY: all clean distclean
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
