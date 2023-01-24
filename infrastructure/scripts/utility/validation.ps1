# This powershell module is designed to perform simple validations on the provided files.
# It should only include functions to help with validation.

function ValidateJsonSchema {
  param (
    [Parameter(
      Mandatory   = $true, 
      HelpMessage = "Path to file to validate against the schema."
    )]
    [string]$File,
  
    # Module-Specific Default Params.
    # Can be overwritten if needed.
    [string]$SchemaFilesPath = "$PSScriptRoot/../../configuration/_schemas"
  )
  
  $data = Get-Content $File -Raw
  if (!(Test-Json $data)) {Throw "$File is not a valid Json. Aborting."}
  
  $dataObject = $data | ConvertFrom-Json
  if (!($dataObject.schema)) {Throw "$File does not define a resource schema."}
  
  $schemaName = ($dataObject.schema).Split("/")[0]
  $schemaVersion = ($dataObject.schema).Split("/")[1]
  $schemaFile = "$SchemaFilesPath/$schemaName/$schemaVersion.json"
  
  if (!(Test-Path "$schemaFile")) {
    Throw "Defined schema was not found in $SchemaFilesPath. $schemaFile does not exist"
  }
  
  if (!(Get-Content $File -Raw | Test-Json -SchemaFile "$schemaFile")) {
    Throw "File $File does not match the defined schema $configurationSchemaFile. 
    You can check the validity of the schema by running the following command:
    Get-Content $File -Raw | Test-Json -SchemaFile $schemaFile"
  }
}