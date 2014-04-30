#!/bin/sh

cpsourcefile="$1"
cp=`basename "${cpsourcefile}" .xml`
dir=`dirname "${cpsourcefile}"`

export XML_CATALOG_FILES="catalogs/catalog.xml"

xsltproc --nonet -o "${dir}/${cp}.fo" stylesheets/customize-fo-pdf-cp.xsl "${cpsourcefile}"
XEP/xep -fo "${dir}/${cp}.fo" -pdf "${dir}/${cp}.pdf"
rm "${dir}/${cp}.fo"

