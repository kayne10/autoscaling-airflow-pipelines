Orchestrating Batch Data Pipelines with Airflow

This repo is a workspace to create, manage, and schedule data pipelines with Apache Airflow.

## Prerequisites
- Docker
- AWS Account
- AWS CLI

## Local Development with Docker
- run `setup_local_dev.sh` to build docker image
- run `docker-compose up` to start container
- visit https://localhost:8080

## List of Pipelines

## Cloud Deployment
- run `deploy_to_aws.sh`
- update server with `bin/cloudformation/deploy.sh`
