Workflow Get-ServerInfo
{
    Param(
        [Parameter(Mandatory=$true)]
        [string[]]$ServerName,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet('SOF','BES')]
        [string]$Location
    )
    
    begin
    {
        Initialize-PoshPrivilege
    }
    
    process
    {
        if ($Location -eq 'SOF')
        {
            $Creds = Get-AutomationPsCredential -Name 'SofCredentials'
        }
        elseif ($Location -eq 'BES')
        {
            $Creds = Get-AutomationPsCredential -Name 'BesCredentials'
        }
        else
        {
            throw 'Unknown Location'
        }
        
        #Execute Get-ServerInfoActivity
        Get-ServerInfoActivity -ComputerName $ServerName -Credential $creds
        
    }
    
    end
    {
        
    }
    
}