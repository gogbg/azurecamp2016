Function Get-AstStatement
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)]
		[System.Management.Automation.Language.Ast]$Ast,

		[Parameter(Mandatory=$false)]
		[type]$Type
	)

	begin
	{

	}

	process
	{
		if ($PSBoundParameters.ContainsKey('Type'))
		{
			$FindAllArgs = @(
				{
					param
					($ast)

					process
					{
						$ast -is $Type
					}
				},
				$true
			)
		}
		else
		{
			$FindAllArgs = @(
				{
					$true
				},
				$true
			)
		}

		$Ast.FindAll($FindAllArgs)
	}

	end
	{

	}

}