FONTSIZE ?= 20
FONTNAME ?= STIXGeneral,STIXSizeOneSym

MATHML = $(wildcard *.xml)
SVG = $(addsuffix .svg, $(basename $(MATHML)))

examples.xhtml: $(SVG)
	./genhtml

%.svg: %.xml pmml2svg.sxx
	../pmml2svg initSize=$(FONTSIZE) fontName=$(FONTNAME) -c $<

pmml2svg.sxx: ../XSLT2/pmml2svg.xsl       ../XSLT2/fontMetrics.xsl \
	      ../XSLT2/formattingMode.xsl ../XSLT2/drawingMode.xsl
	../pmml2svg initSize=$(FONTSIZE) fontName=$(FONTNAME) -compile

clean:
	rm -f pmml2svg.sxx *.svg examples.xhtml
