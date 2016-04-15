function Get-ServerInfoActivitiy
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]]$ComputerName,
        
        [Parameter(Mandatory=$true)]
        [pscredential]$Credential
    )
    
    begin
    {
        $ActivityName = $MyInvocation.MyCommand.Name
        
        $RequiredModules = 'PSRemotingHelper'
    }
    
    process
    {
        #Debug-Activity
        Debug-ActivityStartup -Parameters $PSBoundParameters -Cmdlet $PSCmdlet
        
        foreach ($Computer in $ComputerName)
        {
            #Connect to Computer
            try
            {
                Write-Progress "Connect to Computer:$Computer started"
                
                $tempses = New-PSSession -ComputerName $Computer -Credential $Credential -ErrorAction Stop
                
                Write-Progress "Connect to Computer:$Computer finished"
            }
            catch
            {
                Write-ActivityError -Exeption "Connect to Computer:$Computer failed. Details: $_." `
                                    -Categoty NotSpecified `
                                    -ErrorId 0 `
                                    -TargetObject $ActivityName `
                                    -ErrorAction 'Stop'
            }
            
            #Transfer Module
            try
            {
                Write-Progress "Transfer Module:$RequiredModules started"
                
                $null = Import-TemporaryModule -Name $RequiredModules -PSSession $tempses -ErrorAction Stop
                
                Write-Progress "Transfer Module:$RequiredModules finished"
            }
            catch
            {
                Write-ActivityError -Exeption "Transfer Module:$RequiredModules failed. Details: $_." `
                                    -Categoty NotSpecified `
                                    -ErrorId 0 `
                                    -TargetObject $ActivityName `
                                    -ErrorAction 'Stop'
            }
            
            #Retrieve Computer Information
            try
            {
                Write-Progress "Retrieve Computer:$Computer Information started"
                
                Invoke-Command -PSSession $tempses -ScriptBlock {
                    [pscustomobject]@{
                        Computer=$Env:ComputerName
                        Privileges=(Get-Privilege | select -expandproperty Privilege,Accounts)
                    }
                } -ErrorAction Stop
                
                Write-Progress "Retrieve Computer:$Computer Information finished"
            }
            catch
            {
                Write-ActivityError -Exeption "Retrieve Computer:$Computer Information failed. Details: $_." `
                                    -Categoty NotSpecified `
                                    -ErrorId 0 `
                                    -TargetObject $ActivityName `
                                    -ErrorAction 'Stop'
            }           
            
            
        }
    }
    
    end
    {
        
    }
}