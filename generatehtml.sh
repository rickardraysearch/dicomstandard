#!/bin/sh

part="$1"

export XML_CATALOG_FILES="catalogs/catalog.xml"

mkdir -p "output/html"
cp css/dicom.css output/html/dicom.css

rm -f "output/html/part${part}.html"

partnoleadingzero=`echo "${part}" | sed -e 's/^0//'`

# need -maxdepth 10000 to handle long tables due to recursive row processing (see http://www.sagehill.net/docbookxsl/LongTables.html)
xsltproc -maxdepth 20000 --nonet \
	--stringparam html.stylesheet dicom.css \
	--stringparam target.database.document "../../../olinkdb_html.xml" \
	--stringparam current.docid "PS3.${partnoleadingzero}" \
	-o output/html/part${part}.html \
	stylesheets/customize-html.xsl \
	source/docbook/part${part}/part${part}.xml

mv output/html/part${part}.html output/html/part${part}_withmml.html
java -jar /opt/local/share/java/saxon9he.jar -xsl:pMML2SVG-0.8.5/tools/htmlpmml2svg.xsl -s:output/html/part${part}_withmml.html -o:output/html/part${part}.html
#rm output/html/part${part}_withmml.html

# the following cleans up any peculiarities that upset browsers, e.g., anchors in lists causes suprious new lines ... no additional xmllint options are needed
mv output/html/part${part}.html output/html/part${part}_prexmllint.html
xmllint output/html/part${part}_prexmllint.html >output/html/part${part}.html
rm output/html/part${part}_prexmllint.html

# could edit htmlpmml2svg.xsl to write its MathML converted SVG images to the correct sub-directory, but we will move them and edit references in place (to avoid tool versioning issues): 
sed -i output/html/part${part}.html -e "s/part${part}_withmml_image_/figures\/part${part}_withmml_image_/"
mkdir -p output/html/figures
if [ ! -z `ls -1 output/html/part${part}_withmml_image_*.svg 2>&1| grep -v 'No such file or directory' | head -1` ]
then
  mv -v output/html/part${part}_withmml_image_*.svg output/html/figures/
fi

#(cd output/html; rm -f part${part}_fromword_files; ln -s ../../wordexport/part${part}/part${part}_fromword_files)
rm -rf output/html/part${part}_fromword_files
if [ ! -z `ls -1 wordexport/part${part}/part${part}_fromword_files/*.png 2>&1| grep -v 'No such file or directory' | head -1` ]
then
  mkdir -p output/html/part${part}_fromword_files; cp -v wordexport/part${part}/part${part}_fromword_files/*.png output/html/part${part}_fromword_files
fi
if [ ! -z `ls -1 wordexport/part${part}/part${part}_fromword_files/*.jpg 2>&1| grep -v 'No such file or directory' | head -1` ]
then
  mkdir -p output/html/part${part}_fromword_files; cp -v wordexport/part${part}/part${part}_fromword_files/*.jpg output/html/part${part}_fromword_files
fi
if [ ! -z `ls -1 wordexport/part${part}/part${part}_fromword_files/*.gif 2>&1| grep -v 'No such file or directory' | head -1` ]
then
  mkdir -p output/html/part${part}_fromword_files; cp -v wordexport/part${part}/part${part}_fromword_files/*.gif output/html/part${part}_fromword_files
fi

mkdir -p output/html/figures
if [ ! -z `ls -1 source/docbook/part${part}/figures/*.svg 2>&1| grep -v 'No such file or directory' | head -1` ]
then
  cp -v source/docbook/part${part}/figures/*.svg output/html/figures
fi

cp -v docbook-xsl-ns-1.78.1/images/draft.png output/html/figures
