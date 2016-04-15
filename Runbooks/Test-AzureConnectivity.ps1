$cred = Get-AutomationPsCredential -Name 'BesCredential'

Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -ErrorAction 'Stop'

Invoke-Command -ComputerName 13.94.243.116 -ScriptBlock {
    $env:ComputerName
} -Credential $cred