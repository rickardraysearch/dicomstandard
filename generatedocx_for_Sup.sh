#!/bin/sh

supsourcefile="$1"
sup=`basename "${supsourcefile}" .xml`
dir=`dirname "${supsourcefile}"`

export XML_CATALOG_FILES="catalogs/catalog.xml"

# specify arbitrary part for current.docid to quieten olinkdb use ...
xsltproc --nonet \
	-o "${dir}/${sup}.fo" \
	--stringparam target.database.document "${HOME}/Documents/Work/DICOM_Publish_XML/DocBookDICOM2013/olinkdb_pdf.xml" \
	--stringparam current.docid "PS3.14" \
	stylesheets/customize-fo-pdf-sup.xsl \
	"${supsourcefile}"

xfc_pro_java/bin/fo2docx "-genericFontFamilies=sans-serif=Arial" "${dir}/${sup}.fo" "${dir}/${sup}.docx"
rm "${dir}/${sup}.fo"

