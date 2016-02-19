#!/bin/sh

cpsourcefile="$1"
cp=`basename "${cpsourcefile}" .xml`
dir=`dirname "${cpsourcefile}"`

export XML_CATALOG_FILES="catalogs/catalog.xml"

xsltproc --nonet -o "${dir}/${cp}.fo" stylesheets/customize-fo-pdf-cp.xsl "${cpsourcefile}"

xfc_pro_java/bin/fo2docx "-genericFontFamilies=sans-serif=Arial" "${dir}/${cp}.fo" "${dir}/${cp}.docx"
rm "${dir}/${cp}.fo"

