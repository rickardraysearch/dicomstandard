#!/bin/sh

part="$1"

#XSLTPROC=xsltproc
XSLTPROC=/usr/bin/xsltproc
#XSLTPROC=/opt/local/bin/xsltproc

export XML_CATALOG_FILES="catalogs/catalog.xml"

mkdir -p "output/chtml/targetdb"

"${XSLTPROC}" -maxdepth 10000 --nonet \
	--stringparam collect.xref.targets "only" \
	--stringparam targets.filename "output/chtml/targetdb/PS3_${part}_target.db" \
	stylesheets/customize-chunk.xsl \
	source/docbook/part${part}/part${part}.xml

