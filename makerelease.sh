#!/bin/sh

release=`cat release.txt`
releasedate=`date +%Y%m%d%H%M%S`
releasefilebasename="DocBookDICOM${release}_release"

EXCLUDEFILE="/tmp/Exclude.$$.tmp"

rm -f "${EXCLUDEFILE}"
echo '*CVS*' >"${EXCLUDEFILE}"
echo '*.DS_Store' >>"${EXCLUDEFILE}"

zip "${releasefilebasename}_docbook_${releasedate}.zip" -v -r "-x@${EXCLUDEFILE}" \
	source/docbook/releasenotes/releasenotes_${release}.xml \
	source/docbook/part01/part01.xml \
	source/docbook/part02/part02.xml \
	source/docbook/part03/part03.xml \
	source/docbook/part04/part04.xml \
	source/docbook/part05/part05.xml \
	source/docbook/part06/part06.xml \
	source/docbook/part07/part07.xml \
	source/docbook/part08/part08.xml \
	source/docbook/part10/part10.xml \
	source/docbook/part11/part11.xml \
	source/docbook/part12/part12.xml \
	source/docbook/part14/part14.xml \
	source/docbook/part15/part15.xml \
	source/docbook/part16/part16.xml \
	source/docbook/part17/part17.xml \
	source/docbook/part18/part18.xml \
	source/docbook/part19/part19.xml \
	source/docbook/part20/part20.xml \
	source/docbook/part21/part21.xml \
	source/docbook/part22/part22.xml \
	source/docbook/part01/figures \
	source/docbook/part02/figures \
	source/docbook/part03/figures \
	source/docbook/part04/figures \
	source/docbook/part05/figures \
	source/docbook/part06/figures \
	source/docbook/part07/figures \
	source/docbook/part08/figures \
	source/docbook/part10/figures \
	source/docbook/part11/figures \
	source/docbook/part12/figures \
	source/docbook/part14/figures \
	source/docbook/part15/figures \
	source/docbook/part16/figures \
	source/docbook/part17/figures \
	source/docbook/part18/figures \
	source/docbook/part19/figures \
	source/docbook/part20/figures \
	source/docbook/part21/figures \
	source/docbook/part22/figures \
	support/stylesheets/extractcompositeiodsfordicom3tooltemplate.xsl \
	support/stylesheets/extractcontextgroupsforpixelmed.xsl \
	support/stylesheets/extractdcmdefinitionsasowl.xsl \
	support/stylesheets/extractsrtemplatesforpixelmed.xsl

zip "${releasefilebasename}_docbook_changes_${releasedate}.zip" -v -r "-x@${EXCLUDEFILE}" \
	source/docbook/part01/part01_changes.xml \
	source/docbook/part02/part02_changes.xml \
	source/docbook/part03/part03_changes.xml \
	source/docbook/part04/part04_changes.xml \
	source/docbook/part05/part05_changes.xml \
	source/docbook/part06/part06_changes.xml \
	source/docbook/part07/part07_changes.xml \
	source/docbook/part08/part08_changes.xml \
	source/docbook/part10/part10_changes.xml \
	source/docbook/part11/part11_changes.xml \
	source/docbook/part12/part12_changes.xml \
	source/docbook/part14/part14_changes.xml \
	source/docbook/part15/part15_changes.xml \
	source/docbook/part16/part16_changes.xml \
	source/docbook/part17/part17_changes.xml \
	source/docbook/part18/part18_changes.xml \
	source/docbook/part19/part19_changes.xml \
	source/docbook/part20/part20_changes.xml \
	source/docbook/part21/part21_changes.xml \
	source/docbook/part22/part22_changes.xml

zip "${releasefilebasename}_html_${releasedate}.zip" -v -r "-x@${EXCLUDEFILE}" \
	output/html/targetdb \
	output/html/dicom.css \
	output/html/figures \
	output/html/part01.html \
	output/html/part02.html \
	output/html/part03.html \
	output/html/part04.html \
	output/html/part05.html \
	output/html/part06.html \
	output/html/part07.html \
	output/html/part08.html \
	output/html/part10.html \
	output/html/part11.html \
	output/html/part12.html \
	output/html/part14.html \
	output/html/part15.html \
	output/html/part16.html \
	output/html/part17.html \
	output/html/part18.html \
	output/html/part19.html \
	output/html/part20.html \
	output/html/part21.html \
	output/html/part03_fromword_files \
	output/html/part14_fromword_files \
	output/html/part16_fromword_files \
	output/html/part17_fromword_files \
	output/html/part20_fromword_files \
	output/html/part22_fromword_files

zip "${releasefilebasename}_chtml_${releasedate}.zip" -v -r "-x@${EXCLUDEFILE}" \
	output/chtml/targetdb \
	output/chtml/part01 \
	output/chtml/part02 \
	output/chtml/part03 \
	output/chtml/part04 \
	output/chtml/part05 \
	output/chtml/part06 \
	output/chtml/part07 \
	output/chtml/part08 \
	output/chtml/part10 \
	output/chtml/part11 \
	output/chtml/part12 \
	output/chtml/part14 \
	output/chtml/part15 \
	output/chtml/part16 \
	output/chtml/part17 \
	output/chtml/part18 \
	output/chtml/part19 \
	output/chtml/part20 \
	output/chtml/part21 \
	output/chtml/part22

zip "${releasefilebasename}_pdf_${releasedate}.zip" -v -r "-x@${EXCLUDEFILE}" \
	output/pdf/releasenotes_${release}.pdf \
	output/pdf/part01.pdf \
	output/pdf/part02.pdf \
	output/pdf/part03.pdf \
	output/pdf/part04.pdf \
	output/pdf/part05.pdf \
	output/pdf/part06.pdf \
	output/pdf/part07.pdf \
	output/pdf/part08.pdf \
	output/pdf/part10.pdf \
	output/pdf/part11.pdf \
	output/pdf/part12.pdf \
	output/pdf/part14.pdf \
	output/pdf/part15.pdf \
	output/pdf/part16.pdf \
	output/pdf/part17.pdf \
	output/pdf/part18.pdf \
	output/pdf/part19.pdf \
	output/pdf/part20.pdf \
	output/pdf/part21.pdf \
	output/pdf/part22.pdf

zip "${releasefilebasename}_pdf_changes_${releasedate}.zip" -v -r "-x@${EXCLUDEFILE}" \
	output/pdf/part01_changes.pdf \
	output/pdf/part02_changes.pdf \
	output/pdf/part03_changes.pdf \
	output/pdf/part04_changes.pdf \
	output/pdf/part05_changes.pdf \
	output/pdf/part06_changes.pdf \
	output/pdf/part07_changes.pdf \
	output/pdf/part08_changes.pdf \
	output/pdf/part10_changes.pdf \
	output/pdf/part11_changes.pdf \
	output/pdf/part12_changes.pdf \
	output/pdf/part14_changes.pdf \
	output/pdf/part15_changes.pdf \
	output/pdf/part16_changes.pdf \
	output/pdf/part17_changes.pdf \
	output/pdf/part18_changes.pdf \
	output/pdf/part19_changes.pdf \
	output/pdf/part20_changes.pdf \
	output/pdf/part21_changes.pdf \
	output/pdf/part22_changes.pdf

zip "${releasefilebasename}_docx_${releasedate}.zip" -v -r "-x@${EXCLUDEFILE}" \
	output/docx/part01.docx \
	output/docx/part02.docx \
	output/docx/part03.docx \
	output/docx/part04.docx \
	output/docx/part05.docx \
	output/docx/part06.docx \
	output/docx/part07.docx \
	output/docx/part08.docx \
	output/docx/part10.docx \
	output/docx/part11.docx \
	output/docx/part12.docx \
	output/docx/part14.docx \
	output/docx/part15.docx \
	output/docx/part16.docx \
	output/docx/part17.docx \
	output/docx/part18.docx \
	output/docx/part19.docx \
	output/docx/part20.docx \
	output/docx/part21.docx \
	output/docx/part22.docx

zip "${releasefilebasename}_odt_${releasedate}.zip" -v -r "-x@${EXCLUDEFILE}" \
	output/odt/part01.odt \
	output/odt/part02.odt \
	output/odt/part03.odt \
	output/odt/part04.odt \
	output/odt/part05.odt \
	output/odt/part06.odt \
	output/odt/part07.odt \
	output/odt/part08.odt \
	output/odt/part10.odt \
	output/odt/part11.odt \
	output/odt/part12.odt \
	output/odt/part14.odt \
	output/odt/part15.odt \
	output/odt/part16.odt \
	output/odt/part17.odt \
	output/odt/part18.odt \
	output/odt/part19.odt \
	output/odt/part20.odt \
	output/odt/part21.odt \
	output/odt/part22.odt

rm "${EXCLUDEFILE}"
