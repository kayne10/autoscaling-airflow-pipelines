#!/bin/sh

set -euo pipefail

# Load common vars
readonly DIR=$(pwd)
source "${DIR}/local.env"

TAG_NAME=""

while getopts ":t:" opt; do
  case $opt in
    t)
      echo "Tag option triggered. Preparing to build container with tag: $OPTARG" >&2
      TAG_NAME="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: ./setup_local_dev.sh -t <tag_name> [optional]"
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      echo "Usage: ./setup_local_dev.sh -t <tag_name> [optional]"
      exit 1
      ;;
  esac
done

# Pull latest production image if no image specified
if [[ -z "$TAG_NAME" || "$TAG_NAME" == "" ]]
then
    echo "No image specified. Pulling latest image from ECR"
    docker pull $ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/airflow:latest
    export IMAGE="$ACCOUNT_ID.dkr.ecr.us-west-2.amazonaws.com/airflow:latest"

# Build docker image if tag name is specified
else
    echo "Building: ${TAG_NAME}"
    docker build -t airflow:$TAG_NAME .
    echo "Docker image built successfully. Containers are ready :)"
    export IMAGE="airflow:$TAG_NAME"
fi

# Spin up airflow containers
echo "Spinning up remaining containers..."
docker-compose up -d