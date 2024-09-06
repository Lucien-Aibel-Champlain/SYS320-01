$chrome = Get-Process "chrome" -ea Ignore
if ($chrome)
{
    Stop-Process $chrome
}
else
{
    $chrome = Start-Process "chrome" `
        -ArgumentList "https://www.champlain.edu"
}