#!/usr/bin/env bash

if [[ "${1}" == "" ]]
then
    echo "Please specify a region"
    exit 1
else
    REGION="${1}"
fi

echo "Starting deployment..."
aws cloudformation deploy \
    --stack-name airflow-cloud-stack \
    --template-file config/cloudformation_template.yaml \
    --region ${REGION}

