#!/bin/bash

#Check for correct arguments
if [[ "${#}" != 2 ]]; then
	echo "Invalid number of arguments."
	echo "Correcy syntax: $0 [log file] [IOC file]"
	exit 1
fi

#Get arguments
logFile=$1
IOCFile=$2

#Read each line of the IOCFile, and for each, grep the logFile for that pattern
#Cut at the end grabs the fields we want and sed removes the [ cut leaves dangling
echo "$(cat $IOCFile)" | while read -r line;
do
	result="$(cat $logFile | grep "$line")"
	if [[ "$result" != "" ]]; then
		echo "$result"
	fi
done | cut -d ' ' -f 1,4,7 | sed 's/ \[/ /g' > report.txt

echo "Results saved to report.txt"