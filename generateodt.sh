#!/bin/sh

part="$1"

#XSLTPROC=xsltproc
XSLTPROC=/usr/bin/xsltproc
#XSLTPROC=/opt/local/bin/xsltproc

export XML_CATALOG_FILES="catalogs/catalog.xml"

mkdir -p "output/fo"
mkdir -p "output/odt"

rm -f "output/fo/part${part}.fo"
rm -f "output/odt/part${part}.odt"

partnoleadingzero=`echo "${part}" | sed -e 's/^0//'`

# may need "--xinclude" option to xsltproc since fop does not support includes (see http://www.sagehill.net/docbookxsl/Xinclude.html#JavaXIncludes)
# need -maxdepth 10000 to handle long tables due to recursive row processing (see http://www.sagehill.net/docbookxsl/LongTables.html)

#"${XSLTPROC}" -maxdepth 10000 --nonet -o output/fo/part${part}.fo stylesheets/customize-fo.xsl source/docbook/part${part}/part${part}_tabletest.xml
"${XSLTPROC}" -maxdepth 20000  --maxvars 30000 --nonet \
	--stringparam target.database.document "../../../olinkdb_pdf.xml" \
	--stringparam current.docid "PS3.${partnoleadingzero}" \
	-o output/fo/part${part}.fo \
	stylesheets/customize-fo.xsl \
	source/docbook/part${part}/part${part}.xml

# Handle MathML within FO using pMML2SVG

mv output/fo/part${part}.fo output/fo/part${part}_withmml.fo
java -jar /opt/local/share/java/saxon9he.jar -xsl:pMML2SVG-0.8.5/tools/fopmml2svg.xsl -s:output/fo/part${part}_withmml.fo -o:output/fo/part${part}.fo
rm output/fo/part${part}_withmml.fo

# NS aware stylesheets need fo directory relative paths to figures ...

(cd output/fo; rm -f figures; ln -s ../../source/docbook/part${part}/figures)
(cd output/fo; rm -f part${part}_fromword_files; ln -s ../../wordexport/part${part}/part${part}_fromword_files)

#xfc_pro_java/bin/fo2odt "-genericFontFamilies=sans-serif=Arial Unicode MS" "output/fo/part${part}.fo" "output/odt/part${part}.odt"
xfc_pro_java/bin/fo2odt "-genericFontFamilies=sans-serif=Arial" "output/fo/part${part}.fo" "output/odt/part${part}.odt"
#xfc_pro_java/bin/fo2odt "output/fo/part${part}.fo" "output/odt/part${part}.odt"
