#!/bin/bash

# This is the link we will scrape
link="10.0.17.30/Assignment.html"

# get it with curl and tell curl not to give errors
fullPage=$(curl -sL "$link")

# Utilizing xmlstarlet tool to extract table from the page
toolOutput=$(echo "$fullPage" | \
xmlstarlet format --html --recover 2>/dev/null | \
xmlstarlet select --template --copy-of \
"//html//body//table[1]//tr" | \
awk -F"[><]" '/td/ {print $3}')

data=()
while read -r readData;
do
	read -r time;
	data+=("$readData $time")
done <<< "$toolOutput"

# Utilizing xmlstarlet tool to extract table from the page
toolOutput=$(echo "$fullPage" | \
xmlstarlet format --html --recover 2>/dev/null | \
xmlstarlet select --template --copy-of \
"//html//body//table[2]//tr" | \
awk -F"[><]" '/td/ {print $3}')

i=0
while read -r readData;
do
	read -r time;
	data[$i]="$readData ${data[$i]}"
	i=$((i+1))
done <<< "$toolOutput"

for i in "${data[@]}";
do
	echo "${i}"
done