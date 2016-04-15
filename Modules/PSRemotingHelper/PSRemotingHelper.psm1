function Import-CustomModule
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true,ParameterSetName='ByName')]
		[string]$Name,

		[Parameter(Mandatory=$true,ParameterSetName='ByPath')]
		[string]$Path,

		[Parameter(Mandatory=$true,ParameterSetName='ByPath')]
		[Parameter(Mandatory=$true,ParameterSetName='ByName')]
		[System.Management.Automation.Runspaces.PSSession]$PSSession
	)

	begin
	{

	}

	process
	{
		#Get Module Definition
		if ($PSBoundParameters.ContainsKey('Name'))
		{
			$mod = Get-Module -Name $Name -ErrorAction Stop
			if ($mod)
			{
				$modDefinition = Get-Content -Path $mod.Path -Raw -ErrorAction Stop
			}
			else
			{
				throw "Module: $Name not found"
			}


		}
		elseif ($PSBoundParameters.ContainsKey('Path'))
		{
			try
			{
				$mod = Import-Module $Path -ErrorAction Stop -PassThru
				$modDefinition = Get-Content -Path $mod.Path -Raw -ErrorAction Stop
			}
			catch
			{
				throw "Module on path: $Path not found. Details: $_"
			}
		}

		try
		{
			Invoke-Command -Session $PSSession -ScriptBlock {
				$mod = $Using:mod
				$sb = [scriptblock]::Create($Using:modDefinition)
				$mod = New-Module -Name "Temp_$($mod.Name)" -ScriptBlock $sb -ErrorAction Stop
                Import-Module $mod -ErrorAction Stop -DisableNameChecking
			} -ErrorAction Stop
		}
		catch
		{
			throw "Failed to import module $($mod.Name) on $($PSSession.Name). Details: $_"
		}
	}

	end
	{

	}
}