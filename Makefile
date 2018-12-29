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
	sed -e '1,4d;$$d' $< > $@

install: all
	install -m 0644 download.sty $(TEXMFHOME)/tex/latex/download/download.sty
	install -m 0644 download.pdf $(TEXMFHOME)/doc/latex/download/download.pdf
	install -m 0644 download.tex $(TEXMFHOME)/source/latex/download/download.tex
	install -m 0644 README $(TEXMFHOME)/doc/latex/download/README
	-mktexlsr

download.tar.gz: all
	mkdir -p        download
	cp README       download/README
	cp Makefile     download/Makefile
	cp download.pdf download/download.pdf
	cp download.tex download/download.tex
	cp download.sty download/download.sty
	tar -czf $@ download
	rm -rf download

dist: download.tar.gz

test:
	$(MAKE) -C tests

clean-test:
	$(MAKE) -C tests clean
