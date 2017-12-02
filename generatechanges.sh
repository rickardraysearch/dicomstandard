#!/bin/sh

part="$1"
priorrelease=`cat priorrelease.txt`
priordir="${HOME}/Documents/Medical/stuff/medical.nema.org/MEDICAL/Dicom/${priorrelease}/source/docbook/"

rm -f "source/docbook/part${part}/part${part}_changes.xml"

priorfile="${priordir}/part${part}/part${part}.xml"

if [ ! -f "${priorfile}" ]
then
	priorfile="/tmp/part${part}.xml"
	rm -f "${priorfile}"
	cat <<EOF >"${priorfile}"
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<book xmlns="http://docbook.org/ns/docbook" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xl="http://www.w3.org/1999/xlink" label="PS3.xx" version="5.0" xml:id="PS3.xx">
</book>
EOF
fi

cd DeltaXML-DocBook-Compare
java \
 -Xmx8g \
 -XX:-UseGCOverheadLimit \
 -jar deltaxml-docbook.jar \
 compare \
 "${priorfile}" \
 "../source/docbook/part${part}/part${part}.xml" \
 "../source/docbook/part${part}/part${part}_changes.xml"
