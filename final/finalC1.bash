#!/bin/bash

if [[ "${#}" != 1 ]]; then 
	echo "Invalid number of arguments."
	echo "Correct syntax: $0 [IOC url]"
	exit 1
fi

# This is the link we will scrape
link=$1

# get it with curl and tell curl not to give errors
fullPage=$(curl -sL "$link")

if [[ $fullPage == "" ]]; then
	echo "Couldn't find anything at that url."
	exit 2
fi

# Utilizing xmlstarlet tool to extract table from the page
toolOutput=$(echo "$fullPage" | \
xmlstarlet format --html --recover 2>/dev/null | \
xmlstarlet select --template --copy-of \
"//html//body//table//tr//td")

if [[ $toolOutput == "" ]]; then
	echo "Page has invalid formatting. Error while parsing."
	exit 3
fi

#Removing tags and outputting just the left column (every other td)
echo "$toolOutput" | sed 's/<\/td>/\n/g' | sed 's/<td>//g' | awk 'NR == 0 || NR % 2 == 1' > IOC.txt

echo "Success. Output to IOC.txt"