Workflow Get-ServerInfo
{
    Param(
        [Parameter(Mandatory=$true)]
        [string[]]$ServerName
    )
    
    #Execute Get-ServerInfoActivity
    Get-ServerInfoActivity -ServerName $ServerName
    
}