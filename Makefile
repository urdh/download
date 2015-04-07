TEXMFHOME ?= $(shell kpsewhich -var-value TEXMFHOME)
.PHONY: all clean distclean install dist test clean-test
all: download.tex download.pdf download.sty README
clean: clean-test
	rm -f *.gl? *.id? *.aux # problematic files
	rm -f *.bbl *.bcf *.bib *.blg *.xdy # biblatex
	rm -f *.fls *.log *.out *.run.xml *.toc # junk
distclean: clean
	rm -f *.cls *.sty *.clo *.tar.gz *.tds.zip README
	git reset --hard

%.pdf: %.tex %.sty
	makeglossaries $*
	biber $*
	pdflatex -interaction=nonstopmode -halt-on-error -shell-escape $<
	makeglossaries $*
	pdflatex -interaction=nonstopmode -halt-on-error -shell-escape $<

%.sty: %.tex
	pdflatex -interaction=nonstopmode -halt-on-error $<

README: README.md
	sed -e '1,4d;$$d' README.md > README

install: all
	install -m 0644 download.sty $(TEXMFHOME)/tex/latex/download/download.sty
	install -m 0644 download.pdf $(TEXMFHOME)/doc/latex/download/download.pdf
	install -m 0644 download.tex $(TEXMFHOME)/source/latex/download/download.tex
	install -m 0644 README $(TEXMFHOME)/doc/latex/download/README
	-mktexlsr

download.tds.zip: all
	mkdir -p download/tex/latex/download
	cp download.sty download/tex/latex/download/download.sty
	mkdir -p download/doc/latex/download
	cp download.pdf download/doc/latex/download/download.pdf
	mkdir -p download/source/latex/download
	cp download.tex download/source/latex/download/download.tex
	cp README download/doc/latex/download/README
	cd download && zip -r ../download.tds.zip *
	rm -rf download

download.tar.gz: all download.tds.zip
	mkdir -p download
	cp download.tex download/download.tex
	cp download.pdf download/download.pdf
	cp README download/README
	cp Makefile download/Makefile
	tar -czf $@ download download.tds.zip
	rm -rf download

dist: download.tar.gz

test:
	$(MAKE) -C tests

clean-test:
	$(MAKE) -C tests clean
