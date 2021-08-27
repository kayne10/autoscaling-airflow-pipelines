# Orchestrating Batch Data Pipelines with Airflow

This repo is a workspace to create, manage, and schedule data pipelines with Apache Airflow.

## Prerequisites
- Docker
- AWS Account
- AWS CLI

## Local Development with Docker
- run `./setup_local_dev.sh -t <tag_name>` to start new image
- or run `./setup_local_dev.sh` to pull latest production image from ECR
- everything is setup now visit https://localhost:8080

## List of Pipelines
All data is getting stored cheaply in S3 data lake

- ahwere etl pipeline (practice/test pipeline)
    - takes daily climate data of denver

## Cloud Deployment (not yet ready)

TODO: setup `deploy_to_aws.sh` and cloudformation template

- run `deploy_to_aws.sh`
- update server with `bin/cloudformation/deploy.sh`
