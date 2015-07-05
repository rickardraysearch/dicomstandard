#!/bin/sh

part="$1"

export XML_CATALOG_FILES="catalogs/catalog.xml"

rm -rf output/chtml/part${part}
mkdir -p "output/chtml/part${part}"
cp css/dicom.css output/chtml/part${part}/dicom.css

partnoleadingzero=`echo "${part}" | sed -e 's/^0//'`

mkdir -p "/tmp/chtml/part${part}"
rm -f /tmp/chtml/part${part}/*

# need -maxdepth 10000 to handle long tables due to recursive row processing (see http://www.sagehill.net/docbookxsl/LongTables.html)
xsltproc -maxdepth 10000 --nonet \
	--stringparam html.stylesheet dicom.css \
	--stringparam target.database.document "../../../olinkdb_chtml.xml" \
	--stringparam current.docid "PS3.${partnoleadingzero}" \
	-o "/tmp/chtml/part${part}/part${part}.html" \
	stylesheets/customize-chunk.xsl \
	"source/docbook/part${part}/part${part}.xml"

#ls -l "/tmp/chtml/part${part}"

# needed to edit htmlpmml2svg.xsl to write its MathML converted SVG images to the correct file name, removing '.html' only, not all after first period, else file name collision with chunked parts :(
# use saxon batch feature (supply directory rather than file names for input and output)
java -jar /opt/local/share/java/saxon9he.jar -xsl:pMML2SVG-0.8.5/tools/htmlpmml2svg.xsl "-s:/tmp/chtml/part${part}" "-o:output/chtml/part${part}"

#ls -l "output/chtml/part${part}"
rm -rf "/tmp/chtml/part${part}"

# NB. Saxon batch feature adds ".xml" to ".html" file name :(
for i in output/chtml/part${part}/*.html.xml
do
	mv $i output/chtml/part${part}/`basename $i .xml`
done

#ls -l "output/chtml/part${part}"

for i in output/chtml/part${part}/*.html
do
	# the following cleans up any peculiarities that upset browsers, e.g., anchors in lists causes suprious new lines ... no additional xmllint options are needed
	prexmllintname="output/chtml/part${part}/`basename $i .html`_prexmllint.html"
	mv $i "${prexmllintname}"
	xmllint "${prexmllintname}" >$i
	rm "${prexmllintname}"

	# could edit htmlpmml2svg.xsl to write its MathML converted SVG images to the correct sub-directory, but we will move them and edit references in place (to avoid tool versioning issues): 
	# chunking may produce file names starting with either "chapter" or "sect"
	sed -i $i -e "s/\(ch.*\)_image_/figures\/\1_image_/"
	sed -i $i -e "s/\(sect.*\)_image_/figures\/\1_image_/"
	mkdir -p output/chtml/part${part}/figures
	if [ ! -z `ls -1 output/chtml/part${part}/ch*_image_*.svg 2>&1| grep -v 'No such file or directory' | head -1` ]
	then
		mv -v output/chtml/part${part}/ch*_image_*.svg output/chtml/part${part}/figures/
	fi
	if [ ! -z `ls -1 output/chtml/part${part}/sect*_image_*.svg 2>&1| grep -v 'No such file or directory' | head -1` ]
	then
		mv -v output/chtml/part${part}/sect*_image_*.svg output/chtml/part${part}/figures/
	fi
done

#(cd output/chtml/part${part}; rm -f part${part}_fromword_files; ln -s ../../wordexport/part${part}/part${part}_fromword_files)
rm -rf output/chtml/part${part}/part${part}_fromword_files
if [ ! -z `ls -1 wordexport/part${part}/part${part}_fromword_files/*.png 2>&1| grep -v 'No such file or directory' | head -1` ]
then
  mkdir -p output/chtml/part${part}/part${part}_fromword_files; cp -v wordexport/part${part}/part${part}_fromword_files/*.png output/chtml/part${part}/part${part}_fromword_files
fi
if [ ! -z `ls -1 wordexport/part${part}/part${part}_fromword_files/*.jpg 2>&1| grep -v 'No such file or directory' | head -1` ]
then
  mkdir -p output/chtml/part${part}/part${part}_fromword_files; cp -v wordexport/part${part}/part${part}_fromword_files/*.jpg output/chtml/part${part}/part${part}_fromword_files
fi

mkdir -p output/chtml/part${part}/figures
if [ ! -z `ls -1 source/docbook/part${part}/figures/*.svg 2>&1| grep -v 'No such file or directory' | head -1` ]
then
  cp -v source/docbook/part${part}/figures/*.svg output/chtml/part${part}/figures
fi

cp -v docbook-xsl-ns-1.78.1/images/draft.png output/chtml/part${part}/figures

