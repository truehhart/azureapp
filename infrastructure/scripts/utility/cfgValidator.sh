#!/bin/bash
# Error out if any of the flags is not provided.
while getopts ":f:" flag;
do
  case "${flag}" in
    f) filePath=${OPTARG};;
  esac
done
: "${filePath:?Variable not set or empty}"

# Default variables. Can be overridden.
schemaFilesPath="$(dirname "$(realpath $0)")/../../configuration/_schemas"

# Running general checks against the input file
test -f $filePath || (echo "File $filePath does not exist" && exit 1)
fileContents=$(cat $filePath)
(echo $fileContents | jq -e . > /dev/null 2>&1) || (echo "File $filePath is not a valid json file" && exit 1)

# Grab the schema version from the configuration file
schema=$(echo $fileContents | jq -r .schema)

# Running general checks again the schema
test -f "$schemaFilesPath/$schema.json" || (echo "Schema '$schemaFilesPath/$schema.json' does not exist" && exit 1)
schemaContents=$(cat $schemaFilesPath/$schema.json)
(echo $schemaContents | jq -e . > /dev/null 2>&1) || (echo "Schema '$schemaFilesPath/$schema.json' is not a valid json file" && exit 1)

# Verifying the input file aginst the schema
(cat $filePath | jq -c ) | jsonschema "$schemaFilesPath/$schema.json" || (echo "File $filePath failed schema validation" && exit 1)