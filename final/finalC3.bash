#!/bin/bash

#Check argument number
if [[ "${#}" != 1 ]]; then
	echo "Invalid number of arguments."
	echo "Correcy syntax: $0 [report file]"
	exit 1
fi

#Grab arguments/constants
reportFile=$1
outputFile="/var/www/html/report.html"
templateFile="template.html"

#Read each line and format it into the table's data
result="$(cat $reportFile | while read -r line;
do
	echo "<tr><td>$(echo $line | sed 's/ /<\/td><td>/g')</td></tr>"
done)"

#Escape the HTML slashes for feeding into sed
result="$(echo $result | sed 's/\//\\\//g')"

#Take the template and replace the placeholder with the reported data, then output it
#The template has all the table headers and the rest of the page ready to go
cat $templateFile | sed "s/<!--TABLE CONTENTS-->/$result/g" > $outputFile

echo "Report converted to HTML and stored in $outputFile"