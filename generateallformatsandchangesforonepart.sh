#!/bin/sh

part="$1"

./generateallformatsforonepart.sh "${part}"
./generatechanges.sh "${part}"
./generatepdf_With_Changes.sh "${part}"
