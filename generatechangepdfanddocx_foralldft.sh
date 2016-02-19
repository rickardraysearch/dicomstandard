#!/bin/sh

dftdir="$1"

for dftfilepath in ${dftdir}/cp*.xml
do
	if [ -z `echo "${dftfilepath}" | grep "_changes"` ]
	then
		echo "Doing ${dftfilepath}"
		./generatepdf_for_CP.sh "${dftfilepath}"
		./generatedocx_for_CP.sh "${dftfilepath}"
	fi
done
