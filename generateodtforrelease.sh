#!/bin/sh

PARTSFILE="partsforrelease.txt"

./generatecustomizedtitlepagesfo.sh

for part in `cat "${PARTSFILE}"`
do
	echo "Doing part${part} ..."
	./generateodt.sh "${part}"
done
