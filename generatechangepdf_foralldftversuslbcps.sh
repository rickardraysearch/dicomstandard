#!/bin/sh

lbdir="$1"
dftdir="$2"

for dftfilepath in ${dftdir}/cp*.xml
do
	if [ -z `echo "${dftfilepath}" | grep "_changes"` ]
	then
		dftfile=`basename "${dftfilepath}"`
		lbfile=`echo "${dftfile}" | sed -e 's/_dft[0-9]*_/_lb_/'`
		#echo "Comparing ${lbfile} with ${dftfile}"
		lbfilepath="${lbdir}/${lbfile}"
		if [ -f "${lbfilepath}" ]
		then
			changefilebase=`basename "${dftfile}" .xml`
			changefilepath="${dftdir}/${changefilebase}_changes.xml"
			#echo "Doing ${lbfilepath} versus ${dftfilepath} into ${changefilepath}"
			./generatechanges_for_CP.sh "${lbfilepath}" "${dftfilepath}" "${changefilepath}"
			./generatepdf_for_CP_With_Changes.sh "${changefilepath}"
			rm -f "${changefilepath}"
		fi
	fi
done
