SRCDIR=src
OBJDIR=output
PDF=pdflatex
PDFOPT=-interaction=batchmode # -aux-directory=. # pdflatex does not support it
SOURCES=$(shell find $(SRCDIR) -maxdepth 1 -type f -name "*.tex")
OBJECTS=$(patsubst $(SRCDIR)/%.tex,$(OBJDIR)/%.pdf,$(SOURCES))
PNGFIGS=$(patsubst %.pdf,%.png,$(OBJECTS))

.PHONY: all
all: $(OBJDIR) $(OBJECTS)

# Save some time by not searching for rules for source files
Makefile: ;
%.tex: ;

.PHONY: debug
debug:
	@echo "SOURCES:" ; printf "  %s\n" $(SOURCES)
	@echo "OBJECTS:" ; printf "  %s\n" $(OBJECTS)
	@echo "PNGFIGS:" ; printf "  %s\n" $(PNGFIGS)

$(OBJDIR):
	mkdir -p $(OBJDIR)

$(OBJDIR)/%.pdf: $(SRCDIR)/%.tex preamble.tex
	TEXINPUTS=".:utils/general:" \
	$(PDF) $(PDFOPT) -output-directory=$(OBJDIR) $<

%.png: %.pdf
	convert -density 600 $< -resize @1000000 $@

pngs: $(PNGFIGS) ;
.PHONY: pngs

.PHONY: clean
clean:
	-rm $(OBJDIR)/*.aux $(OBJDIR)/*.log $(OBJDIR)/*.png $(OBJECTS)
