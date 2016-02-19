#!/bin/sh

supsourcefile="$1"
sup=`basename "${supsourcefile}" .xml`
dir=`dirname "${supsourcefile}"`

export XML_CATALOG_FILES="catalogs/catalog.xml"

xsltproc --nonet \
	-o "${dir}/${sup}.fo" \
	--stringparam target.database.document "${HOME}/Documents/Work/DICOM_Publish_XML/DocBookDICOM2013/olinkdb_pdf.xml" \
	--stringparam current.docid "PS3.14" \
	stylesheets/customize-fo-pdf-sup_with_changes.xsl \
	"${supsourcefile}"


#XEP/xep -fo "${dir}/${sup}.fo" -pdf "${dir}/${sup}.pdf"

XEP/xep -fo "${dir}/${sup}.fo" -xep "${dir}/${sup}.xep"
java -jar /opt/local/share/java/saxon9he.jar "-xsl:stylesheets/linenumberxep.xsl" "-s:${dir}/${sup}.xep" "-o:${dir}/${sup}_linenumbered.xep"
XEP/xep -xep "${dir}/${sup}_linenumbered.xep" -pdf "${dir}/${sup}.pdf"

rm "${dir}/${sup}.fo"
rm "${dir}/${sup}_linenumbered.xep"
rm "${dir}/${sup}.xep"
