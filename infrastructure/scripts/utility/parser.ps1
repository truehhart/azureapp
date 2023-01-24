# parser PowerShell module is needed for quick and easy configuration parsing.
# This module allows us to store environment variables as Json structs within the repository,
#   as opposed to keeping them in the powershell scripts.

function ParseARMGlobalConfiguration {
  param (
    [Parameter(
      Mandatory   = $true, 
      HelpMessage = "Environment to get the variables from, example: 'prod'. Case-sensitive."
    )]
    [string]$Environment,
  
    # Module-Specific Default Params.
    # Can be overwritten if needed.
    [string]$ConfigurationFilesPath = "$PSScriptRoot/../../configuration"
  )

  # Make sure that necessary scripts are available
  $dependancies = 'validation'
  foreach ($dependancy in $dependancies) {
    try {. "$PSScriptRoot/$dependancy.ps1"}
    catch {Throw "Could not source mandatory dependancy $dependancy from $PSScriptRoot/$dependancy.ps1."}
  }

  $globalConfigFile        = "$ConfigurationFilesPath/global/$Environment.json"
  $configurationSchemaFile = "$SchemaFilesPath/configuration.json"
  
  $globalConfigFileExists = Test-Path "$globalConfigFile"
  if (!($globalConfigFileExists)) {
    Throw "Global configuration file was not found. $globalConfigFile does not exist"
  }
  $_ = ValidateJsonSchema -File $globalConfigFile

  $globalConfigParams = Get-Content $globalConfigFile -Raw | ConvertFrom-Json -AsHashTable


  return $globalConfigParams.params
}