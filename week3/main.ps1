. (Join-Path $PSScriptRoot EventLogsFuncions.ps1)

clear

#Get last 15 days of logins/logouts
$accessTable = getAccessLog(15)
$accessTable

#Get last 25 days of shutdowns
$shutdownsTable = getShutdowns(25)
$shutdownsTable

#Get last 25 days of startups
$startupsTable = getStartups(25)
$startupsTable