#! /bin/bash

authfile="/var/log/auth.log"

function getLogins(){
 logline=$(cat "$authfile" | grep "systemd-logind" | grep "New session")
 dateAndUser=$(echo "$logline" | cut -d' ' -f1,2,3,4,12 | tr -d '\.')
 echo "$dateAndUser" 
}

function getFailedLogins(){
 logline=$(cat "$authfile" | grep "authentication failure")
 dateAndUser=$(echo "$logline" | cut -d' ' -f1,2,3,4,17 | tr -d '\.')
 echo "$dateAndUser" 
}

# Sending logins as email - Do not forget to change email address
# to your own email address
echo -e "To: lucien.aibel@mymail.champlain.edu\nSubject: Logins\nSuccessful logins\n$(getLogins)\n\
	Failed logins\n$(getFailedLogins)\n" | ssmtp lucien.aibel@mymail.champlain.edu