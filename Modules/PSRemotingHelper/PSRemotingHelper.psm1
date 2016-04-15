function Import-TemporaryModule
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true,ParameterSetName='RemotingWithSession_ByName')]
		[string]$Name,

		[Parameter(Mandatory=$true,ParameterSetName='RemotingWithSession_ByPath')]
		[string]$Path,

		[Parameter(Mandatory=$true,ParameterSetName='RemotingWithSession_ByPath')]
		[Parameter(Mandatory=$true,ParameterSetName='RemotingWithSession_ByName')]
		[System.Management.Automation.Runspaces.PSSession]$PSSession
	)

	begin
	{

	}

	process
	{
		#Check if Module exists and get it`s definition
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

		#Transfer and import in the remote sessions
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