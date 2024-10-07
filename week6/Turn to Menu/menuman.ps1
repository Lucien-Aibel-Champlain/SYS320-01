. (Join-Path $PSScriptRoot .. | Join-Path -ChildPath week4 | Join-Path -ChildPath Apache-Logs.ps1)
. (Join-Path $PSScriptRoot .. | Join-Path -ChildPath week2 | Join-Path -ChildPath processmanagement.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - Display last 10 apache logs`n"
$Prompt += "2 - Display last 10 failed logins for all users`n"
$Prompt += "3 - Display at risk users`n"
$Prompt += "4 - Start Chrome web browser and navigate it to champlain.edu`n"
$Prompt += "5 - Exit`n"

$operation = $true

while($operation) {

    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 5){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }
    elseif($choice -eq 1) {
        Write-Host (ApacheLogs1 | Sort Time -Descending | Select -first 10 | Format-Table | Out-String)
    }
    elseif($choice -eq 2) {
        Write-Host (getFailedLogins(90) | Sort Time -Descending | Select -first 10 | Format-Table | Out-String)
    }
    elseif($choice -eq 3) {
        Write-Host (getFailedLogins(90) | Group-Object -Property "User" | Where-Object { $_.Count -gt 10 } | Select Name, Count | Format-Table | Out-String)
    }
    elseif ($choice -eq 4) {
        chromeNav
    }
    else {
        Write-Host "Invalid operation. Please try again."
    }
}