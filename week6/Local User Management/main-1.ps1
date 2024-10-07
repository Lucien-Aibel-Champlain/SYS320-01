. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - Check At-Risk Users`n"
$Prompt += "10 - Exit`n"



$operation = $true

while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 10){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }


    # Create a user
    elseif($choice -eq 3){ 

        $name = Read-Host -Prompt "Please enter the username for the new user"
        
        if (checkUser($name)) {
            Write-Host "User already exists."
        }
        else {
            $passwordValid = 0
            while (-not $passwordValid) {
                $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"
                $passwordValid = checkPassword($password)
            }

            createAUser $name $password
            Write-Host "User: $name is created." | Out-String
        }
    }


    # Remove a user
    elseif($choice -eq 4){

        $name = Read-Host -Prompt "Please enter the username for the user to be removed"
        
        if (-not (checkUser($name))) {
            Write-Host "User doesn't exist."
        }
        else {
            removeAUser $name

            Write-Host "User: $name Removed." | Out-String
        }
    }


    # Enable a user
    elseif($choice -eq 5){


        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"
        
        if (-not (checkUser($name))) {
            Write-Host "User doesn't exist."
        }
        else {
            enableAUser $name

            Write-Host "User: $name Enabled." | Out-String
        }
    }


    # Disable a user
    elseif($choice -eq 6){

        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"

        
        if (-not (checkUser($name))) {
            Write-Host "User doesn't exist."
        }
        else {
            disableAUser $name
            Write-Host "User: $name Disabled." | Out-String
        }
    }


    elseif($choice -eq 7) {
        $escape = 0
        while (-not $escape) {
            $name = Read-Host -Prompt "Please enter the username for the user logs"
        
            if (checkUser($name)) {
                $escape = 1
            }
            else {
                Write-Host "User doesn't exist."
            }
        }
        
        $n = " "
        while (-not ($n -match "[0-9]{1,}")) {
            if ($n -ne " ") {
                Write-Host "Invalid number."
            }
            $n = Read-Host -Prompt "Days back of logins/offs to fetch"
        }
        $userLogins = getLogInAndOffs($n -as [int])
        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }


    elseif($choice -eq 8){
        $escape = 0
        while (-not $escape) {
            $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"
        
            if (checkUser($name)) {
                $escape = 1
            }
            else {
                Write-Host "User doesn't exist."
            }
        }
        $n = " "
        while (-not ($n -match "[0-9]{1,}")) {
            if ($n -ne " ") {
                Write-Host "Invalid number."
            }
            $n = Read-Host -Prompt "Days back of failed logins to fetch"
        }
        $userLogins = getFailedLogins($n -as [int])
        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }

    elseif($choice -eq 9) {
        $n = " "
        while (-not ($n -match "[0-9]{1,}")) {
            if ($n -ne " ") {
                Write-Host "Invalid number."
            }
            $n = Read-Host -Prompt "Days back of failed logins to fetch"
        }
        $userLogins = getFailedLogins($n -as [int])
        Write-Host ($userLogins | Group-Object -Property "User" | Where-Object { $_.Count -gt 10 } | Select Name, Count | Format-Table | Out-String)
    }
    
    else {
        Write-Host "Invalid operation. Please try again."
    }
}




