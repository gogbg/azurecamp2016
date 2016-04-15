function ConvertTo-String
{
  [CmdletBinding()]
  param
  (
    [ValidateScript({
          If ('Hashtable','OrderedDictionary','AXNodeConfiguration','PSBoundParametersDictionary' -contains $_.GetType().Name)
          {
            $true
          }
          else
          {
            throw "Supported InputTypes are 'Hashtable' and 'OrderedDictionary'"
          }
    })]
    $InputObject
  )
  
  begin
  {
    function _priv-ConvertKey
    {

      param
      (
        [string]$KeyName,
        $InputObject,
        [System.Text.StringBuilder]$StringBuilder
      )

      process
      {
  
        $null =  $sb.AppendLine("$KeyName=@{")
    
        foreach ($key in $InputObject.Keys)
        {
    
          switch ($InputObject[$key].GetType().Name)
          {
			'ScriptBlock' {
				$null = $sb.AppendLine("$key=`{$($inputObject[$key].ToString())`}")
				break
			}
			'String'  { 
			  $null = $sb.AppendLine("$key=`'$($inputObject[$key])`'")
			  break
			}
            'String[]'  { 
			  $null = $sb.AppendLine("$key=`'$($inputObject[$key])`'")
			  break
			}
			{$_ -ilike '*int*'} {
			  $null = $sb.AppendLine("$key=$($inputObject[$key])") 
			  break
			}
			{'Hashtable','OrderedDictionary','PSBoundParametersDictionary' -contains $_}  { 
			  _priv-ConvertKey -InputObject ($inputObject["$key"]) -StringBuilder $sb -KeyName $key 
			  break
			}
			'SwitchParameter' {
			  $null = $sb.AppendLine("$key=`$$($inputObject[$key].ToString())")
			  break
			}
			'Boolean' {
			  $null = $sb.AppendLine("$key=`$$($inputObject[$key].ToString())")
			  break
			}
			Default {
				Write-Warning "Serializing not supported key: $key that contains: $_"
				$null = $sb.AppendLine("$key=$($inputObject[$key].ToString())")
			}
          }
    
        }
      
        $null =  $sb.AppendLine('}')
  
      }

    }
  }
  
  process
  {
    $sb = new-object System.Text.StringBuilder
    $null = $sb.AppendLine('@{')
    foreach ($key in $inputObject.Keys)
    {
    
      switch ($inputObject[$key].GetType().Name)
      {
        'ScriptBlock' {
            $null = $sb.AppendLine("$key=`{$($inputObject[$key].ToString())`}")
            break
        }
        'String'  { 
          $null = $sb.AppendLine("$key=`'$($inputObject[$key])`'")
          break
        }
        'String[]' {
          $null = $sb.AppendLine("$key=`'$($inputObject[$key])`'")
          break
        }
        {$_ -ilike '*int*'} {
          $null = $sb.AppendLine("$key=$($inputObject[$key])") 
          break
        }
        {'Hashtable','OrderedDictionary','PSBoundParametersDictionary' -contains $_}  { 
          _priv-ConvertKey -InputObject ($inputObject["$key"]) -StringBuilder $sb -KeyName $key 
          break
        }
		'SwitchParameter' {
		  $null = $sb.AppendLine("$key=`$$($inputObject[$key].ToString())")
          break
		}
		'Boolean' {
		  $null = $sb.AppendLine("$key=`$$($inputObject[$key].ToString())")
          break
		}
		Default {
			Write-Warning "Serializing not supported key: $key that contains: $_"
			$null = $sb.AppendLine("$key=$($inputObject[$key].ToString())")
		}
      }
    
    }
    $null =  $sb.AppendLine('}')
    
    $result = $sb.ToString()
    
    ConvertTo-TabifiedString -ScriptText $result
  }

}

function ConvertTo-Hashtable
{

	param
	(
		[ValidateScript({
		switch ($_)
		{
			'System.String' {
				try
				{
					$obj = ConvertFrom-Json -InputObject $_ -ErrorAction Stop
					$Script:InputObjectData = $obj.psobject.Properties
				}
				catch
				{
					throw "InputObject is not a valid json string"
				}
				break
			}
			default {
				$Script:InputObjectData = $_.psobject.Properties
			}
		}
		$true
	})]
		$InputObject
	)

	begin
	{
		$DepthThreshold = 32

		function Get-IOProperty
		{
			param
			(
				[Parameter(Mandatory=$true)]
				[System.Management.Automation.PSPropertyInfo[]]$Property,

				[Parameter(Mandatory=$true)]
				[int]$CurrentDepth
			)
			
			#Increse and chech Depth
			$CurrentDepth++
			if ($Function:Depth -ge $DepthThreshold)
			{
				Write-Error -Message "Converting to Hashtable reached Depth Threshold of 32 on $($Property.Name -join ',')" -ErrorAction Stop
			}

			$Ht = [hashtable]@{}
			foreach ($Prop in $Property)
			{
			switch ($Prop.TypeNameOfValue)
			{
				'System.String' {
					$ht.Add($Prop.Name,$Prop.Value)
					break
				}
				'System.Boolean' {
					$ht.Add($Prop.Name,$Prop.Value)
					break
				}
				'System.DateTime' {
					$ht.Add($Prop.Name,$Prop.Value.ToString())
					break
				}
				{$_ -ilike '*int*'} {
					$ht.Add($Prop.Name,$Prop.Value)
					break
				}
				default {
					$ht.Add($Prop.Name,(Get-IOProperty -Property $Prop.Value.psobject.Properties -CurrentDepth $CurrentDepth))
				}
			}
			}
			$Ht
		}
	}
  
	process
	{
		$CurrentDepth = 0
		Get-IOProperty -Property $InputObjectData -CurrentDepth $CurrentDepth
	}
  
	end
	{
	}
}

function ConvertTo-TabifiedString
{
	[CmdletBinding()]
	Param
	(
		$ScriptText
	) 
	
	$CurrentLevel = 0
	$ParseError = $null
	$Tokens = $null
	$AST = [System.Management.Automation.Language.Parser]::ParseInput($ScriptText, [ref]$Tokens, [ref]$ParseError) 
	
	if($ParseError) { 
	$ParseError | Write-Error
	throw 'The parser will not work properly with errors in the script, please modify based on the above errors and retry.'
	}
	
	for($t = $Tokens.Count -2; $t -ge 1; $t--) {
		
	$Token = $Tokens[$t]
	$NextToken = $Tokens[$t-1]
		
	if ($token.Kind -match '(L|At)Curly') { 
		$CurrentLevel-- 
	}  
		
	if ($NextToken.Kind -eq 'NewLine' ) {
		# Grab Placeholders for the Space Between the New Line and the next token.
		$RemoveStart = $NextToken.Extent.EndOffset  
		$RemoveEnd = $Token.Extent.StartOffset - $RemoveStart
		$tabText = "`t" * $CurrentLevel 
		$ScriptText = $ScriptText.Remove($RemoveStart,$RemoveEnd).Insert($RemoveStart,$tabText)
	}
		
	if ($token.Kind -eq 'RCurly') { 
		$CurrentLevel++ 
	}     
	}

	$ScriptText
}