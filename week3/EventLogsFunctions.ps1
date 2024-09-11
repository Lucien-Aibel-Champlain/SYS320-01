function getAccessLog($days) {
$accessLog = Get-EventLog "System" -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-1 * $days)
$accessLogTable = @()

for ($i = 0; $i -lt $accessLog.count; $i++) {

#Translate instance id to a name for the event
$event = ""
if ($accessLog[$i].InstanceId -eq 7001) { $event = "Logon" }
elseif ($accessLog[$i].InstanceId -eq 7002) { $event = "Logoff" }

#Make an object to hold the user's security identifier. We'll translate this in a minute; storing this makes
    #sure we can clean up the New-Object later. That's just my intuition
$user = New-Object System.Security.Principal.SecurityIdentifier($accessLog[$i].ReplacementStrings[1])

#Add a clean entry to the table with the data we care about, including the stuff we just translated
$accessLogTable += [pscustomobject]@{"Time" = $accessLog[$i].TimeGenerated; `
                                     "Id" = $accessLog[$i].InstanceId; `
                                     "Event" = $event; `
                                     "User" = $user.Translate([System.Security.Principal.NTAccount]).Value; `
                                     }
}

return $accessLogTable
}

function getStartups($days) {
$accessLog = Get-EventLog "System" -Source Eventlog -After (Get-Date).AddDays(-1 * $days)
$accessLogTable = @()

for ($i = 0; $i -lt $accessLog.count; $i++) {

if ($accessLog[$i].EventId -eq 6005) {
    #Add a clean entry to the table with the data we care about
    $accessLogTable += [pscustomobject]@{"Time" = $accessLog[$i].TimeGenerated; `
                                         "Id" = $accessLog[$i].EventId; `
                                         "Event" = "Startup"; ` #Since we've already filtered down to just the event we care about, we know its name
                                         "User" = "System"; `
                                         }
    }
}

return $accessLogTable
}

function getShutdowns($days) {
$accessLog = Get-EventLog "System" -Source Eventlog -After (Get-Date).AddDays(-1 * $days)
$accessLogTable = @()

for ($i = 0; $i -lt $accessLog.count; $i++) {

if ($accessLog[$i].EventId -eq 6006) {

    #Add a clean entry to the table with the data we care about
    $accessLogTable += [pscustomobject]@{"Time" = $accessLog[$i].TimeGenerated; `
                                         "Id" = $accessLog[$i].EventId; `
                                         "Event" = "Shutdown"; ` #Since we've already filtered down to just the event we care about, we know its name
                                         "User" = "System"; `
                                         }
    }
}

return $accessLogTable
}