#!/bin/sh

cpsourcefile="$1"
cp=`basename "${cpsourcefile}" .xml`
dir=`dirname "${cpsourcefile}"`

export XML_CATALOG_FILES="catalogs/catalog.xml"

xsltproc --nonet -o "${dir}/${cp}.fo" stylesheets/customize-fo-pdf-cp.xsl "${cpsourcefile}"

#XEP/xep -fo "${dir}/${cp}.fo" -pdf "${dir}/${cp}.pdf"

XEP/xep -fo "${dir}/${cp}.fo" -xep "${dir}/${cp}.xep"
java -jar /opt/local/share/java/saxon9he.jar "-xsl:stylesheets/linenumberxep.xsl" "-s:${dir}/${cp}.xep" "-o:${dir}/${cp}_linenumbered.xep"
XEP/xep -xep "${dir}/${cp}_linenumbered.xep" -pdf "${dir}/${cp}.pdf"

rm "${dir}/${cp}.fo"
rm "${dir}/${cp}_linenumbered.xep"
rm "${dir}/${cp}.xep"

