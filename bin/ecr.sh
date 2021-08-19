#!/usr/bin/env bash

# Define vars
ECR_REGISTRY_NAME="my-aws-airflow"
# readonly cmd="${1}"
readonly TAG_NAME="${1}"
readonly REGION="${2}"

# login to ecr
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin "${ACCOUNT_ID}.ecr.${REGION}.amazonaws.com"

# tag
docker tag airflow:${TAG_NAME} ${ECR_REGISTRY_NAME}:${TAG_NAME}

#push
docker push ${ECR_REGISTRY_NAME}:${TAG_NAME}