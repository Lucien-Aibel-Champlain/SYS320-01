<# String-Helper
*************************************************************
   This script contains functions that help with String/Match/Search
   operations. 
************************************************************* 
#>


<# ******************************************************
   Functions: Get Matching Lines
   Input:   1) Text with multiple lines  
            2) Keyword
   Output:  1) Array of lines that contain the keyword
********************************************************* #>
function getMatchingLines($contents, $lookline){

$allines = @()
$splitted =  $contents.split([Environment]::NewLine)

for($j=0; $j -lt $splitted.Count; $j++){  
 
   if($splitted[$j].Length -gt 0){  
        if($splitted[$j] -ilike $lookline){ $allines += $splitted[$j] }
   }

}

return $allines
}

function checkPassword($password) {
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
    $plainStr = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

    if ($plainStr.Length -lt 6) {
        Write-Host "Password too short. Must be at least 6 characters."
        return 0
    }
    if ($plainStr -inotmatch "[a-zA-Z]") {
        Write-Host "Password must contain at least 1 letter."
        return 0
    }
    if ($plainStr -inotmatch "[0-9]") {
        Write-Host "Password must contain at least 1 number."
        return 0
    }
    if ($plainStr -inotmatch "[!@#$%^&\*()]") {
        Write-Host "Password must contain at least 1 special character."
        return 0
    }
    return 1
}