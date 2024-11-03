#!bin/bash
#for i in {0..19}
#do
#	curl 10.0.17.23 
#done

allLogs=""
file="/var/log/apache2/access.log"
#cat "$file" | grep "GET /page2.html" | cut -d' ' -f1,7 | tr -d "/"


function getAllLogs() {
allLogs=$(cat "$file" | cut -d' ' -f1,4,7 | tr -d "[")
}

function pageCount() {
sortedPages=$(echo "$allLogs" | cut -d' ' -f3 | sort | uniq -c)
}

function countingCurlAccess(){
curlAccesses=$(cat "$file" | grep "curl" | cut -d' ' -f1,12 | uniq -c)
}

#getAllLogs
#pageCount
#echo "$sortedPages"

countingCurlAccess
echo "$curlAccesses"
