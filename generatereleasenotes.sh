#!/bin/sh

release=`cat release.txt`

basefile="releasenotes_${release}"

export XML_CATALOG_FILES="catalogs/catalog.xml"

mkdir -p "output/fo"
mkdir -p "output/pdf"

xsltproc --nonet -o "output/fo/${basefile}.fo" stylesheets/customize-fo-pdf-releasenotes.xsl "source/docbook/releasenotes/${basefile}.xml"
XEP/xep -fo "output/fo/${basefile}.fo" -pdf "output/pdf/${basefile}.pdf"
rm "output/fo/${basefile}.fo"
