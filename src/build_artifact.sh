#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

PY_VERSION="${BUILD_PY_VERSION:-3.9}"
# Use the current directory name
ARTIFACT_FILE_NAME="${BUILD_FILE_NAME:-${PWD##*/}}.zip"

output_directory="/var/task/output"
artifact_path="$output_directory/$ARTIFACT_FILE_NAME"
handler_name="lambda_handler.py"

venv_location=$(pipenv --venv 2> /dev/null)
venv_lib_location="$venv_location/lib/python$PY_VERSION/site-packages"

# We need all the contents of the venv in the root of the zipfile
cd "$venv_lib_location" && zip -rq9 "$artifact_path" . && cd -
zip -gq9 "$artifact_path" "$handler_name"
