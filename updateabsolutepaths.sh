#!/bin/sh

abspath=`pwd | sed -e 's/\//\\\\\//g'`

sedstring="s/\"file:\/\/.*\"/\"file:\/\/${abspath}\/\"/"
echo "${sedstring}"
sed -i catalogs/catalog.xml -e "${sedstring}"

sedstring="s/\"file:\/\/.*output/\"file:\/\/${abspath}\/output/"
echo "${sedstring}"
sed -i olinkdb_html.xml -e "${sedstring}"
sed -i olinkdb_pdf.xml -e "${sedstring}"

