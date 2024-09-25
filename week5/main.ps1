. (Join-Path $PSScriptRoot champclasses.ps1)

$fullTable = gatherClasses

Write-Host "Listing all of Furkan Paligu's classes"
$fullTable | Select "Class Code", "Instructor", "Location", "Days", "Start Time", "End Time" |`
    Where-Object {$_."Instructor" -ilike "Furkan Paligu"} 

Write-Host "Listing Class Code and Times of all JOYCE 310 classes on Mondays, sorted by Start Time"
$fullTable | Where-Object {($_."Location" -ilike "JOYC 310") -and ($_."Days" -contains "Monday")} |`
    Sort-Object -Property "Start Time" | Format-Table "Class Code", "Start Time", "End Time"

Write-Host "Listing all instructors who teach at least one course of SYS NET SEC FOR CSI or DAT, sorted by name"
$ITSInstructors = $fullTable | Where-Object {($_."Class Code" -ilike "SYS*") -or `
                                             ($_."Class Code" -ilike "NET*") -or `
                                             ($_."Class Code" -ilike "SEC*") -or `
                                             ($_."Class Code" -ilike "FOR*") -or `
                                             ($_."Class Code" -ilike "CSI*") -or `
                                             ($_."Class Code" -ilike "DAT*") } `
                             | Select "Instructor" `
                             | Sort-Object -Property "Instructor" -Unique

$ITSInstructors | Format-Table

Write-Host "Grouping instructors by number of classes"
$fullTable | Where-Object {$_.Instructor -in $ITSInstructors.Instructor } |`
           Group-Object -Property "Instructor" | Select Count, Name | `
           Sort-Object -Property Count -Descending