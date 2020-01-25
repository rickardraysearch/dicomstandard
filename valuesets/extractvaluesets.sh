#!/bin/sh

FHIRJSONFOLDER="valuesets/fhir/json"
FHIRXMLFOLDER="valuesets/fhir/xml"
IHESVSXMLFOLDER="valuesets/ihe/svs"

TEMPCGFILE="/tmp/contextgroups.xml"

rm -f "${TEMPCGFILE}"

xsltproc -maxdepth 10000 --nonet \
	-o "${TEMPCGFILE}" \
	../support/stylesheets/extractcontextgroupsforpixelmed.xsl \
	../source/docbook/part16/part16.xml

# UTF8 encoding of source because of copyright symbol
javac -encoding "UTF8" -cp .:${HOME}/work/pixelmed/imgbook/lib/additional/javax.json-api-1.0.jar ContextGroupExtraction.java

mkdir -p "${FHIRJSONFOLDER}"
mkdir -p "${FHIRXMLFOLDER}"
mkdir -p "${IHESVSXMLFOLDER}"

#do NOT want to remove entire folder since we track contents with CVS

rm -f ${FHIRJSONFOLDER}/*.json
rm -f ${FHIRXMLFOLDER}/*.xml
rm -f ${IHESVSXMLFOLDER}/*.xml

java -cp .:${HOME}/work/pixelmed/imgbook/lib/additional/javax.json-api-1.0.jar::${HOME}/work/pixelmed/imgbook/lib/additional/javax.json-1.0.4.jar ContextGroupExtraction \
	"${TEMPCGFILE}" \
	"${FHIRJSONFOLDER}" \
	"${FHIRXMLFOLDER}" \
	"${IHESVSXMLFOLDER}"

#rm "${TEMPCGFILE}"

