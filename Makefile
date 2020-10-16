
PANDOC=pandoc
XELATEX=xelatex
BIBER=biber
RM=rm
CP=cp
SED = sed
PANDOCCROSSREF=--filter=pandoc-crossref


all: CANSSI_Letter_of_Submission.pdf CANSSI_Application.pdf

budget.md: budget.Rmd
	R -e "base::library('base');knitr::knit('$<',encoding='UTF-8')" $(Rargs)

%.tex: %.Rmd
	$(PANDOC) --standalone $(PANDOCCROSSREF) --biblatex $(pandocArgs) --from=markdown --to=latex $< | $(SED) s/\\\\usepackage{subfig}// > $@

%.bbl: %.bcf 
	$(BIBER) $<

%.bcf: %.tex bibliography.bib
	$(XELATEX) -interaction=nonstopmode $<

%.aux: %.tex
	$(XELATEX) -interaction=nonstopmode $<


%.pdf: %.tex %.bbl %.aux
	$(XELATEX) -interaction=nonstopmode $<;
	$(XELATEX) $<

%.pdf: %.md
	$(PANDOC) --from=markdown --to=pdf --output=$@ $<



clean:
	rm *.aux *.bbl *.bcf *.log *.run.xml *.blg