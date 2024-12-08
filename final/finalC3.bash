#!/bin/bash

if [[ "${#}" != 1 ]]; then
	echo "Invalid number of arguments."
	echo "Correcy syntax: $0 [report file]"
	exit 1
fi

reportFile=$1
outputFile="/var/www/html/report.html"
templateFile="template.html"

result="$(cat $reportFile | while read -r line;
do
	echo "<tr><td>$(echo $line | sed 's/ /<\/td><td>/g')</td></tr>"
done)"

result="$(echo $result | sed 's/\//\\\//g')"

cat $templateFile | sed "s/<!--TABLE CONTENTS-->/$result/g" > $outputFile