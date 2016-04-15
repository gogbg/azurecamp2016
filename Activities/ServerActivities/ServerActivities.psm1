function Get-ServerInfoActivitiy
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,ParameterSetName='Azure')]
        [Parameter(Mandatory=$true,ParameterSetName='OnPremise')]
        [string[]]$ComputerName,
        
        [Parameter(Mandatory=$true,ParameterSetName='Azure')]
        [Parameter(Mandatory=$true,ParameterSetName='OnPremise')]
        [pscredential]$Credential,
        
        [Parameter(Mandatory=$true,ParameterSetName='Azure')]
        [switch]$Azure,
        
        [Parameter(Mandatory=$true,ParameterSetName='Azure')]
        [string]$ResourceGroupName
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
            if ($PSCmdlet.ParameterSetName -eq 'Azure')
            {
                try
                {
                    Write-Progress "Connect to Computer:$Computer started"
                    
                    Write-Progress "Connect to Computer:$Computer in progress. Retrieve AzureVm"
                    
                    
                    
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
            }
            else
            {
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
            }
            
            #Retrieve Computer Information
            try
            {
                Write-Progress "Retrieve Computer:$Computer Information started"
                
                Invoke-Command -PSSession $tempses -ScriptBlock {
                    [pscustomobject]@{
                        Computer=$Env:ComputerName
                        Services=(Get-Serice)
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