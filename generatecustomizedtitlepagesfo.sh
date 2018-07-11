#!/bin/sh

# see "http://www.sagehill.net/docbookxsl/TitlePageNewElems.html"

#XSLTPROC=xsltproc
XSLTPROC=/usr/bin/xsltproc
#XSLTPROC=/opt/local/bin/xsltproc

export XML_CATALOG_FILES="catalogs/catalog.xml"

"${XSLTPROC}" --nonet \
	-o stylesheets/customizedtitlepages-fo.xsl \
	docbook-xsl-ns-1.78.1/template/titlepage.xsl \
	stylesheets/customized-titlepage.templates-fo.xml
