#!/bin/bash
# Error out if any of the flags is not provided.
while getopts ":e:a:" flag;
do
  case "${flag}" in
    # Environment to get the variables from, example: 'prod'. Case-sensitive.
    e) environment=${OPTARG};;
    # Whether to automatically confirm the deployment or not.
    a) approve=${OPTARG};;
  esac
done
: "${environment:?Variable not set or empty}"

# Default variables. Can be overridden.
scriptPath=$(dirname "$(realpath $0)")
configurationFilesPath="$scriptPath/../../configuration/global"
resourceDefinitionsPath="$scriptPath/../../resourceDefinitions"
moduleName="ResourceGroup"
resourceDefinitionName="azure$moduleName"

dependancies=("$scriptPath/../utility/cfgValidator.sh")
for dep in ${dependancies[@]}; do
  test -f $dep || (echo "Could not resolve dependancy '$dep" || exit 1)
done
# Check auto-approve
if [[ $approve != true ]]; then
  askWhatIf="-c"
else
  askWhatIf=""
fi

# Validate the configuration file against it's schema
environmentConfigurationFile="$configurationFilesPath/$environment.json"
$scriptPath/../utility/cfgValidator.sh -f $environmentConfigurationFile
params=$(cat "$environmentConfigurationFile" | jq -c .params)

# Resource-specific deployment configuration
echo "Starting deployment $(echo $params | jq -r .environmentParams.value.environment)-$moduleName-$(date +%s)..."
az deployment sub create \
  --name "$(echo $params | jq -r .environmentParams.value.environment)-$moduleName-$(date +%s)" \
  --location "$(echo $params | jq -r .environmentParams.value.az.location)" \
  --parameters $params \
  --template-file "$resourceDefinitionsPath/$resourceDefinitionName.json" \
  $askWhatIf
