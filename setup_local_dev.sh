#!/bin/sh

set -euo pipefail

# Load common vars
readonly DIR=$(pwd)
source "${DIR}/local.env"

TAG_NAME="${1}"

# Build docker image
if [[ "$TAG_NAME" == "" ]]
then
    echo "Please provide a tag name"
    exit 1
else
    echo "Preparing Docker image for tag: ${TAG_NAME}"
    docker build -t airflow:$TAG_NAME .
    echo "Docker image built successfully. Containers are ready :)"
fi

# Spin up airflow containers
echo "Spinning up remaining containers..."
docker-compose up -d