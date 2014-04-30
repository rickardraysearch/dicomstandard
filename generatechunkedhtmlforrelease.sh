#!/bin/sh

PARTSFILE="partsforrelease.txt"

./generatecustomizedtitlepageshtml.sh

for part in `cat "${PARTSFILE}"`
do
	echo "Doing part${part} ..."
	./generatechunkedhtml.sh "${part}"
done
