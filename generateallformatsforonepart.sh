#!/bin/sh

part="$1"

./generatehtml.sh "${part}"
./generatechunkedhtml.sh "${part}"
./generatepdf.sh "${part}"
./generatedocx.sh "${part}"
./generateodt.sh "${part}"
