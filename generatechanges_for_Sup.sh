#!/bin/sh

oldsourcefile="$1"
newsourcefile="$2"
changefile="$3"

rm -f "${changefile}"

cd DeltaXML-DocBook-Compare-3_0_4_w
java -Xmx2g -jar deltaxml-docbook.jar compare \
 "${oldsourcefile}" \
 "${newsourcefile}" \
 "${changefile}"
