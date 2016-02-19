#!/bin/sh

part="$1"
priorrelease=`cat priorrelease.txt`
priordir="${HOME}/Documents/Medical/stuff/medical.nema.org/MEDICAL/Dicom/${priorrelease}/source/docbook/"

rm -f "source/docbook/part${part}/part${part}_changes.xml"

cd DeltaXML-DocBook-Compare-3_0_4_w
java -Xmx4g -jar deltaxml-docbook.jar compare \
 "${priordir}/part${part}/part${part}.xml" \
 "../source/docbook/part${part}/part${part}.xml" \
 "../source/docbook/part${part}/part${part}_changes.xml"
