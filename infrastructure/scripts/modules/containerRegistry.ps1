param (
  [Parameter(
    Mandatory   = $true, 
    HelpMessage = "Environment to get the variables from, example: 'prod'. Case-sensitive."
  )]
  [string]$Environment,
  [Parameter(
    Mandatory   = $false, 
    HelpMessage = "Whether to automatically confirm the deployment or not."
  )]
  [switch]$Approve = $false,

  # Module-Specific Default Params.
  # Can be overwritten if needed.
  [string]$resourceDefinitionsPath = "$PSScriptRoot/../../resourceDefinitions",
  [string]$resourceDefinitionName = "azureContainerRegistry",
  [string]$moduleName = "containerRegistry"
)

# Make sure that necessary scripts are available
$dependancies = '../utility/parser'
foreach ($dependancy in $dependancies) {
  try {. "$PSScriptRoot/$dependancy.ps1"}
  catch {Throw "Could not source mandatory dependancy $dependancy from $PSScriptRoot/$dependancy.ps1."}
}

$resourceDefinition = Get-Content "$resourceDefinitionsPath/$resourceDefinitionName.json" -Raw | ConvertFrom-Json 
$templateConfiguration = ParseARMGlobalConfiguration -Environment $Environment
$stage                  = $templateConfiguration.environmentParams.stage

$DeploymentParams = @{
  Name         = "$Environment-$moduleName"
  TemplateFile = "$resourceDefinitionsPath/$resourceDefinitionName.json"
  TemplateParameterObject = $templateConfiguration
  ResourceGroupName       = "$Environment-$stage-rg"
}
if (!$Approve) {$DeploymentParams.Confirm = $true}

New-AzResourceGroupDeployment @DeploymentParams