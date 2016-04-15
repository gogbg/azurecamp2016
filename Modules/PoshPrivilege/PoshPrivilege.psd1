
#
# PoshPrivilege
# Version 0.3.0.0
#
# Module manifest for module 'PoshPrivilege'
#
# Generated by: Boe Prox
#
# Generated on: 04/06/2015
#

@{

# Script module or binary module file associated with this manifest
ModuleToProcess = 'PoshPrivilege.psm1'

# Version number of this module.
ModuleVersion = '0.3.0.0'

# ID used to uniquely identify this module
GUID = 'e1ef944e-38f4-4024-85cc-7140088c891d'

# Author of this module
Author = 'Boe Prox'

# Company or vendor of this module
CompanyName = 'NA'

# Copyright statement for this module
Copyright = '(c) 2015 Boe Prox. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Module designed to use allow easier access to work with User Rights (privileges)'

# Minimum version of the Windows PowerShell engine required by this module
#PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
#PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
#PowerShellHostVersion = ''

# Minimum version of the .NET Framework required by this module
#DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
#CLRVersion = ''

# Processor architecture (None, X86, Amd64, IA64) required by this module
#ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
#RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
#RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module
#ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
#TypesToProcess = ''

# Format files (.ps1xml) to be loaded when importing this module
#FormatsToProcess = ''

# Modules to import as nested modules of the module specified in ModuleToProcess
#NestedModules = @()

# Functions to export from this module
FunctionsToExport = @(
    "Add-Privilege", 
    "Disable-Privilege", 
    "Enable-Privilege", 
    "Get-Privilege", 
    "Remove-Privilege"
)

# Cmdlets to export from this module
#CmdletsToExport = '*'

# Variables to export from this module
#VariablesToExport = '*'

# Aliases to export from this module
#AliasesToExport = '*'

# List of all modules packaged with this module
#ModuleList = @()

# List of all files packaged with this module
FileList = 'PoshPrivilege.psd1','PoshPrivilege.psm1',
    'Scripts\Disable-Privilege.ps1',
    'Scripts\Enable-Privilege.ps1',
    'Scripts\Get-Privilege.ps1',
    'Scripts\Add-Privilege.ps1'

# Private data to pass to the module specified in ModuleToProcess
PrivateData = ''

}

