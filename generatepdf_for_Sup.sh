#!/bin/sh

supsourcefile="$1"
sup=`basename "${supsourcefile}" .xml`
dir=`dirname "${supsourcefile}"`

export XML_CATALOG_FILES="catalogs/catalog.xml"

xsltproc --nonet -o "${dir}/${sup}.fo" stylesheets/customize-fo-pdf-sup.xsl "${supsourcefile}"
XEP/xep -fo "${dir}/${sup}.fo" -pdf "${dir}/${sup}.pdf"
rm "${dir}/${sup}.fo"

