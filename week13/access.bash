#!/bin/bash

echo "File was accessed $(date)" >> "/home/champuser/Desktop/SYS320-01/week13/fileaccesslog.txt"

echo -e "To: lucien.aibel@mymail.champlain.edu\nSubject: Access\nuserlogs-1.bash was recently accessed at\
	\n$(cat /home/champuser/Desktop/SYS320-01/week13/fileaccesslog.txt | sed -r 's/:/-/g' | tail -n 10)\n" \
	| ssmtp lucien.aibel@mymail.champlain.edu