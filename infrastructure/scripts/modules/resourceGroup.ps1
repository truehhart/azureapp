param (
  [Parameter(
    Mandatory   = $true, 
    HelpMessage = "Environment to get the variables from, example: 'prod'. Case-sensitive."
  )]
  [string]$Environment,

  # Module-Specific Default Params.
  # Can be overwritten if needed.
  [string]$resourceDefinitionsPath = "$PSScriptRoot/../../resourceDefinitions",
  [string]$resourceDefinitionName = "azureResourceGroup",
  [string]$moduleName = "resourceGroup"
)

# Make sure that necessary scripts are available
$dependancies = '../utility/parser'
foreach ($dependancy in $dependancies) {
  try {. "$PSScriptRoot/$dependancy.ps1"}
  catch {Throw "Could not source mandatory dependancy $dependancy from $PSScriptRoot/$dependancy.ps1."}
}

$timestamp          = Get-Date -Format "ddMMyyyy-hhmmss"
$resourceDefinition = Get-Content "$resourceDefinitionsPath/$resourceDefinitionName.json" -Raw | ConvertFrom-Json 
$templateConfiguration = ParseARMGlobalConfiguration -Environment $Environment
  # -AzureResourceSchema $resourceDefinition.'$schema' `
  # -AzureContentVersion $resourceDefinition.contentVersion

# echo $templateConfiguration
New-AzResourceGroupDeployment -Name "$moduleName-$timestamp" `
  -TemplateFile "$resourceDefinitionsPath/$resourceDefinitionName.json" `
  -TemplateParameterObject $templateConfiguration `
  -WhatIf 