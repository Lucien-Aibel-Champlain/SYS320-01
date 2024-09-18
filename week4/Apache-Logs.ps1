function getLogsWhere($vars) {
#Extract variables 
$page = $vars[0]
$code = $vars[1]
$browser = $vars[2]
#Get logs and filter for relevant targets
$results = Get-Content C:\xampp\apache\logs\access.log | Select-String $page `
    | Where-Object {$_ -ilike "*$code*" } | Where-Object {$_ -ilike "*$browser*"}
    
#define regex for finding IPs
$regex = [regex] "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"

#use the regex to find all ips in the filtered logs
$unsortedIPs = $regex.Matches($results)

#format ips into pscustomobjects
$ips = @()
for ($i = 0; $i -lt $unsortedIPs.Count; $i++) {
    $ips += [pscustomobject]@{"IP" = $unsortedIPs[$i].Value;}
}
#final filtering
$ips = $ips | Where-Object {$_.IP -ilike "10.*"}

#Count occurances of each IP
$counts = $ips | Group IP
$counts | Select-Object Count, Name

return $counts
}

function ApacheLogs1() {
    $logsUnformatted = Get-Content C:\xampp\apache\logs\access.log
    $tableRecords = @()

    #for each entry
    for ($i = 0; $i -lt $logsUnformatted.Count; $i++) {
        #split the entry into its individual words
        $words = $logsUnformatted[$i].Split(" ");

        #list out notable properties into a table
        $tableRecords += [pscustomobject]@{ "IP" = $words[0];`
                                            "Time" = $words[3].Trim('[');`
                                            "Method" = $words[5].Trim('"');`
                                            "Page" = $words[6];`
                                            "Protocol" = $words[7];`
                                            "Response" = $words[8];`
                                            "Referrer" = $words[10];`
                                            "Client" = $words[11..($words.Count)]; }
    }
    return $tableRecords | Where-Object {$_.IP -ilike "10.*"};
}