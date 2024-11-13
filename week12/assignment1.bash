#! /bin/bash
clear

# filling courses.txt
bash courses.bash

courseFile="courses.txt"

function displayCoursesofInst(){

echo -n "Please Input an Instructor Full Name: "
read instName

echo ""
echo "Courses of $instName :"
cat "$courseFile" | grep "$instName" | cut -d';' -f1,2 | \
sed 's/;/ | /g'
echo ""

}

function courseCountofInsts(){

echo ""
echo "Course-Instructor Distribution"
cat "$courseFile" | cut -d';' -f7 | \
grep -v "/" | grep -v "\.\.\." | \
sort -n | uniq -c | sort -n -r 
echo ""

}

function courseLocation() {
	echo "Enter a building location (ex. JOYC 310)"
	read loc

	loc=$(echo "$loc" | sed 's/-/ /g')
	
	echo "Classes in $loc"
	cat "$courseFile" | grep "$loc" | cut -d';' -f1,2,5,6,7 | \
	sed 's/;/ | /g'
	echo ""
}

function coursesAvailable() {
	echo "Course code to check"
	read courseCode

	echo "Courses in $courseCode with availability"
	cat "$courseFile" | grep "$courseCode" | while read -r line;
	do
		if (( $(echo "$line" | cut -d';' -f4) > 0 )); then
			echo "$line" | sed 's/;/ | /g'
		fi
	done
}

while :
do
	echo ""
	echo "Please select and option:"
	echo "[1] Display courses of an instructor"
	echo "[2] Display course count of instructors"
	echo "[3] Display all courses in a given location"
	echo "[4] Display only courses with availibility"
	echo "[5] Exit"

	read userInput
	echo ""

	if [[ "$userInput" == "5" ]]; then
		echo "Goodbye"
		break

	elif [[ "$userInput" == "1" ]]; then
		displayCoursesofInst

	elif [[ "$userInput" == "2" ]]; then
		courseCountofInsts

	elif [[ "$userInput" == "3" ]]; then
		courseLocation

	elif [[ "$userInput" == "4" ]]; then
		coursesAvailable
	
	else
		echo "I'm sorry, I didn't understand that. Please try again."
	fi
done
