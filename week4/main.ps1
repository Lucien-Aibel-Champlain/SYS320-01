. (Join-Path $PSScriptRoot Apache-Logs.ps1)

getLogsWhere("index.html","200","Chrome")

$tableLogs = ApacheLogs1
$tableLogs | Format-Table -AutoSize -Wrap