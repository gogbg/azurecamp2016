function Add-PSModulePathEntry
{
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        #Path
        [Parameter(Mandatory=$true,ParameterSetName='NoRemoting_Default')]
        [string[]]$Path,

		[Parameter(Mandatory=$false,ParameterSetName='NoRemoting_Default')]
        [switch]$Force = $false
    )
    
    Begin
    {
          
    }

    Process
    {
		$CurPSModulePathArr = New-Object -TypeName System.Collections.ArrayList
		$CurPSModulePathArr.AddRange((Get-PSModulePath))
		foreach ($Item in $Path)
		{
			if ((Test-Path $Item) -or ($Force.IsPresent))
			{
				$null = $CurPSModulePathArr.Add($Item)
			}
			else
			{
				Write-Error -Message "Path: $Item does not exits" -ErrorAction Stop
			}
		}

		[System.Environment]::SetEnvironmentVariable('PsModulePath',($CurPsModulePathArr -join ';'),[System.EnvironmentVariableTarget]::Machine)
    }

    End
    {

    }
}

function Set-PSModulePath
{
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        #parameter1
        [Parameter(Mandatory=$true,ParameterSetName='NoRemoting_Default')]
        [string[]]$Path,

		[Parameter(Mandatory=$false,ParameterSetName='NoRemoting_Default')]
        [switch]$Force = $false
    )
    
    Begin
    {
          
    }

    Process
    {
		$CurPsModulePathArr = New-Object System.Collections.ArrayList
		foreach ($Item in $Path)
		{
			if ((Test-Path $Item) -or ($Force.IsPresent))
			{
				$CurPsModulePathArr += $Item
			}
			else
			{
				Write-Error -Message "Path: $Item does not exits" -ErrorAction Stop
			}

		}

		[System.Environment]::SetEnvironmentVariable('PsModulePath',($CurPsModulePathArr -join ';'),[System.EnvironmentVariableTarget]::Machine)
    }

    End
    {

    }
}

function Get-PSModulePath
{
    [CmdletBinding()]
    [OutputType([string[]])]
    param
    (

    )
    
    Begin
    {
          
    }

    Process
    {
		[System.Environment]::GetEnvironmentVariable('PsModulePath',[System.EnvironmentVariableTarget]::Machine) -split ';'
    }

    End
    {

    }
}

function Remove-PSModulePath
{
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        #Path
        [Parameter(Mandatory=$true,ParameterSetName='NoRemoting_Default')]
        [string[]]$Path
    )
    
    Begin
    {
          
    }

    Process
    {
		$CurPsModulePathArr = New-Object -TypeName System.Collections.ArrayList
		$CurPsModulePathArr.AddRange((Get-PSModulePath))
		foreach ($Item in $Path)
		{
			if ($CurPSModulePath -contains $Item)
			{
				$CurPsModulePathArr.Remove($Item)
			}
			else
			{
				Write-Warning "PSModulePath does not contains: $Item"
			}
		}

		[System.Environment]::SetEnvironmentVariable('PsModulePath',($CurPsModulePathArr -join ';'),[System.EnvironmentVariableTarget]::Machine)
    }

    End
    {

    }
}