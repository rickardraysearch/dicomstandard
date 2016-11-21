#!/bin/sh

cpsourcefile="$1"
cp=`basename "${cpsourcefile}" .xml`
dir=`dirname "${cpsourcefile}"`

export XML_CATALOG_FILES="catalogs/catalog.xml"

xsltproc --nonet \
	-o "${dir}/${cp}.fo" \
	--stringparam target.database.document "${HOME}/Documents/Work/DICOM_Publish_XML/DocBookDICOM2013/olinkdb_pdf.xml" \
	--stringparam current.docid "PS3.14" \
	stylesheets/customize-fo-pdf-cp_with_changes.xsl \
	"${cpsourcefile}"


#XEP/xep -fo "${dir}/${cp}.fo" -pdf "${dir}/${cp}.pdf"

XEP/xep -fo "${dir}/${cp}.fo" -xep "${dir}/${cp}.xep"
java -jar /opt/local/share/java/saxon9he.jar "-xsl:stylesheets/linenumberxep.xsl" "-s:${dir}/${cp}.xep" "-o:${dir}/${cp}_linenumbered.xep"
XEP/xep -xep "${dir}/${cp}_linenumbered.xep" -pdf "${dir}/${cp}.pdf"

rm "${dir}/${cp}.fo"
rm "${dir}/${cp}_linenumbered.xep"
rm "${dir}/${cp}.xep"

# object-streams=generate makes the difference in reducing size, when ENABLE_ACCESSIBILITY is true in xep.xml to create tagged pdf; stream-data=compress makes no difference and is the default
mv "${dir}/${cp}.pdf" "${dir}/${cp}.pdf.bak"
qpdf --object-streams=generate --stream-data=compress --linearize "${dir}/${cp}.pdf.bak" "${dir}/${cp}.pdf"
rm "${dir}/${cp}.pdf.bak"
