#!/bin/sh

PARTSFILE="partsforrelease.txt"

for part in `cat "${PARTSFILE}"`
do
	echo "Doing part${part} ..."
	./generateolinkdb.sh "${part}"
done
