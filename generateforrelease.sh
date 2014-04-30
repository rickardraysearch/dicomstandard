#!/bin/sh

./generatereleasenotes.sh

./generateolinkdbforrelease.sh
./generateolinkdbchunkedforrelease.sh
./generatehtmlforrelease.sh
./generatechunkedhtmlforrelease.sh
./generatepdfforrelease.sh

if [ -f xfc_pro_java/bin/fo2docx ]
then
	./generatedocxforrelease.sh
fi
if [ -f xfc_pro_java/bin/fo2odt ]
then
	./generateodtforrelease.sh
fi

