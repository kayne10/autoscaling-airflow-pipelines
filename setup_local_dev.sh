#!/bin/sh

set -euo pipefail

# Load common vars
readonly DIR=$(pwd)
source "${DIR}/local.env"

readonly TAG_NAME="${1}"

if [[ "$TAG_NAME" == "" ]]
then
    echo "Please provide a tag name"
    exit 1
else
    echo "Building Docker image"
    docker-compose up -d airflow_image
    echo "Docker image built successfully. Containers are ready :)"
    exit 0
