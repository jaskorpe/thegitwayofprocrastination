# Makefile for latex and bibtex

# Name of latex "project"
TARGET = master

# Name of bibtex references
REFERENCES = references.bib

# Svg figures to be included in project. Pdf for pdflatex and eps for
# latex.
SVG_FIG = $(wildcard *.svg)
PDF_FIG = $(SVG_FIG:.svg=.pdf)
EPS_FIG = $(SVG_FIG:.svg=.eps)

# Also do recompile if any tex files have changed. This is mainly for
# \input. Could lead to unexpected behaviour. Maybe use another suffix
# for files which should be \input'ed.
TEX_FILES = $(wildcard *.tex)

LATEX_WORK_FILES = $(TARGET).aux $(TARGET).bbl $(TARGET).blg \
	$(TARGET).lof $(TARGET).log $(TARGET).lot $(TARGET).toc \
	texput.log

.PHONY : all clean realclean $(SVG_FIGS) pdf fig

all: pdf

pdf: $(TARGET).pdf

fig: $(PDF_FIG) $(EPS_FIG)


%.eps: %.svg
	inkscape -z -C --export-eps=$@ $< 2> /dev/null

%.pdf: %.svg
	inkscape -z -C --export-pdf=$@ $< 2> /dev/null


${TARGET}.dvi: $(TARGET).tex $(EPS_FIG) $(REFERENCES) $(TEX_FILES)
	latex $<
	bibtex $(TARGET)
	latex $<
	latex $<


$(TARGET).pdf: $(TARGET).tex $(PDF_FIG) $(REFERENCES) $(TEX_FILES)
	pdflatex $<
	bibtex $(TARGET)
	pdflatex $<
	pdflatex $<


clean:
	rm -f $(LATEX_WORK_FILES) *~

realclean: clean
	rm -f $(TARGET).pdf $(TARGET).dvi $(PDF_FIG) $(EPS_FIG)