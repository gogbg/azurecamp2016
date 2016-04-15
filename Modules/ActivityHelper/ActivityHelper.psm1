function Debug-ActivityStartup
{
	[CmdletBinding()]
	param
	(
		#Parameters
		[Parameter(Mandatory=$true)]
		[hashtable]$Parameters,

		#Cmdlet
		[Parameter(Mandatory=$true)]
		[ValidateScript({
          If ('PSScriptCmdlet' -contains $_.GetType().Name)
          {
            $true
          }
          else
          {
            throw "Supported PSCmdlet type is 'PSScriptCmdlet'"
          }
		})]
		$Cmdlet
	)

	Write-Debug @"
  Starting: $($Cmdlet.MyInvocation.MyCommand.Name)
  ParameterSet: $($Cmdlet.ParameterSetName)
  with params: $(ConvertTo-String -InputObject $Parameters)		

"@

}

function Write-ActivityError
{
	[CmdletBinding()]
	param
	(
		#Exception
		[Parameter(Mandatory=$true)]
		[string]$Exception,

		#Message
		[Parameter(Mandatory=$false)]
		[string]$Message,

		#Category
		[Parameter(Mandatory=$true)]
		[System.Management.Automation.ErrorCategory]$Category,

		#ErrorId
		[Parameter(Mandatory=$true)]
		[int]$ErrorId,

		#TargetObject
		[Parameter(Mandatory=$true)]
		[object]$TargetObject
	)
	
	begin
	{
	}

	process
	{
		$WriteError_params = @{
			Exception=$Exception
			Category=$Category
			ErrorId=$ErrorId
			TargetObject=$TargetObject
		}
		if ($PSBoundParameters.ContainsKey('Message'))
		{
			$WriteError_params.Add('Message',$Message)
		}
		else
		{
			$WriteError_params.Add('Message',$Exception)
		}

		Write-Error @WriteError_params -ErrorAction Continue
		if ($ErrorActionPreference -eq 'Stop')
		{
			Write-Error @WriteError_params
		}
	}

	end
	{

	}

}