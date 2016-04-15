Function Get-DerivedType
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [string]$BaseType,

        [Parameter(Mandatory=$true)]
        [ValidateSet('AppDomain','File')]
        [string]$Scope,

        [Parameter(Mandatory=$false)]
        [switch]$Recurse
    )

    DynamicParam
    {

            #Assembly
            $Assembly_AttrColl = new-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $Assembly_Param = new-object -Type System.Management.Automation.RuntimeDefinedParameter('Assembly',[string[]],$Assembly_AttrColl)

            if ($Scope -eq 'AppDomain')
            {
                $Assembly_Attr1 = new-object System.Management.Automation.ParameterAttribute
                $Assembly_Attr1.Mandatory = $false
                $Assembly_Param.Attributes.Add($Assembly_Attr1)
                $Assembly_Param.Value = [System.AppDomain]::CurrentDomain.GetAssemblies().FullName

                $Assembly_Attr2 = New-Object System.Management.Automation.ValidateSetAttribute -ArgumentList ([System.AppDomain]::CurrentDomain.GetAssemblies().FullName)
                $Assembly_Param.Attributes.Add($Assembly_Attr2)
            }
            else
            {
                $Assembly_Attr1 = new-object System.Management.Automation.ParameterAttribute
                $Assembly_Attr1.Mandatory = $true
                $Assembly_Param.Attributes.Add($Assembly_Attr1)
            }

            $DynamicParams = new-object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
            $DynamicParams.Add('Assembly',$Assembly_Param)
            $DynamicParams.Keys | foreach {
                $PSBoundParameters.Add($_,$DynamicParams[$_].Value)
            }
            $DynamicParams
    }

    begin
    {

        Function priv_Resolve-DerivedType
        {
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory=$true)]
                [string]$BaseType,

                [Parameter(Mandatory=$true)]
                [System.Reflection.Assembly[]]$Assembly,

                [Parameter(Mandatory=$false)]
                [switch]$Recurse
            )

            process
            {
                $Assembly.ExportedTypes | foreach {

                    if ($_.BaseType.FullName -eq $BaseType)
                    {
                        $_
                        if ($Recurse.IsPresent)
                        {
                            priv_Resolve-DerivedType -BaseType $_.FullName -Assembly $Assembly -Recurse:$Recurse.IsPresent
                        }
                    }

                }
            }
        }

    }

    process
    {
        #Resolve Assembly
        $ResolvedAssembly = $PSBoundParameters['Assembly'] | foreach {
            [System.Reflection.Assembly]::Load($_)
        }

        priv_Resolve-DerivedType -BaseType $BaseType -Recurse:$Recurse.IsPresent -Assembly $ResolvedAssembly
    }

    end
    {
    
    }    

}