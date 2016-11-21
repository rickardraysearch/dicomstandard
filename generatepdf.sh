#!/bin/sh

part="$1"

export XML_CATALOG_FILES="catalogs/catalog.xml"

mkdir -p "output/fo"
mkdir -p "output/xep"
mkdir -p "output/pdf"

rm -f "output/fo/part${part}.fo"
#rm -f "output/pdf/part${part}_tabletest.pdf"
#rm -f "output/pdf/part${part}.pdf"

partnoleadingzero=`echo "${part}" | sed -e 's/^0//'`

# may need "--xinclude" option to xsltproc since fop does not support includes (see http://www.sagehill.net/docbookxsl/Xinclude.html#JavaXIncludes)
# need -maxdepth 10000 to handle long tables due to recursive row processing (see http://www.sagehill.net/docbookxsl/LongTables.html)

#xsltproc -maxdepth 10000 --nonet -o output/fo/part${part}.fo stylesheets/customize-fo.xsl source/docbook/part${part}/part${part}_tabletest.xml
xsltproc -maxdepth 10000 --nonet \
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

# need to turn off (remove file) in draft.watermark.image in stylesheets/customize-fo.xsl for fop, else get serialization error :(
#fop -conserve -c lib/fop/fop.xml -fo output/fo/part${part}.fo -pdf "/tmp/part${part}_fop.pdf"

XEP/xep -fo "output/fo/part${part}.fo" -pdf "output/pdf/part${part}.pdf"

#XEP/xep -fo "output/fo/part${part}.fo" -xep "output/xep/part${part}.xep"
#java -jar /opt/local/share/java/saxon9he.jar "-xsl:stylesheets/linenumberxep.xsl" "-s:output/xep/part${part}.xep" "-o:output/xep/part${part}_linenumbered.xep"
#XEP/xep -xep "output/xep/part${part}_linenumbered.xep" -pdf "output/pdf/part${part}.pdf"

# embed all fonts and make tagged PDF ...
#/usr/local/AHFormatterV61/run.sh -tpdf -peb 2 -i lib/ahf/AHFormatter.xml -d "output/fo/part${part}.fo" -o "/tmp/part${part}_ahf.pdf"

# object-streams=generate makes the difference in reducing size, when ENABLE_ACCESSIBILITY is true in xep.xml to create tagged pdf; stream-data=compress makes no difference and is the default
mv "output/pdf/part${part}.pdf" "output/pdf/part${part}.pdf.bak"
qpdf --object-streams=generate --stream-data=compress --linearize "output/pdf/part${part}.pdf.bak" "output/pdf/part${part}.pdf"
rm "output/pdf/part${part}.pdf.bak"
