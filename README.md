# Orchestrating Batch Data Pipelines with Airflow

This repo is a workspace to create, manage, and schedule data pipelines with Apache Airflow. Cloud deployment is capable of building an autoscaling ECS cluster. The specs of the cluster is configurable in `service.yml`.

## Prerequisites
- Docker
- AWS Account
- AWS CLI

## Requirements
To get things going locally, create a virtual environment.
```bash
python -m venv venv
```
Then setup environment variables.
```bash
export AWS_REGION=us-west-2;
export AWS_PROFILE=default;
export ACCOUNT_ID=<aws_account_id>
export ENVIRONMENT=dev;
```
I have a Dag that contains additional environment variables such as an Api key and auth url. Add additional env variables now as well.
```bash
export AWHERE_ENCODED_KEY=<encoded_key>
export AWHERE_TOKEN_URL=<ahwere_api_url>
```
Last environment variable to export is the Fernet key. Create it with this command.
```bash
export FERNET_KEY=$(python -c 'from cryptography.fernet import Fernet; fernet_key = Fernet.generate_key().decode(); print(fernet_key)')
```

## Deploy locally
```bash
make airflow-local
```

## Deploy to AWS ECS
First add `FERNET_KEY` value to AWS Secrets Manager with name of `airflow-dev-fernet-key`
Second, deploy current image of stable docker image to ECR
```bash
make push-to-ecr tag=v1.0.0
```
All set now for ECS deployment with cloudformation templates
```bash
make airflow-deploy
```
To update current image (such as updating or creating new DAG) without infrastructure changes.
```bash
make airflow-push-image
```
This will restart the airflow service in the ECS cluster

### Access Airflow UI
The url is in the output of AirflowWebServerEndpoint from webserver cloudformation stack
```json
"cfn-airflow-webserver": [
    {
        "OutputKey": "AirflowWebServerEndpoint",
        "OutputValue": "airflow-dev-webserver-alb-1501286483.us-west-2.elb.amazonaws.com"
    }
]
```
### Access Flower UI
The url is in the output of AirflowFlowerEndpoint from cloudformation flower cloudformation stack
```json
"cfn-airflow-flower": [
    {
        "OutputKey": "AirflowFlowerEndpoint",
        "OutputValue": "airflow-dev-flower-alb-1290838679.us-west-2.elb.amazonaws.com"
    }
]
```

## Testing

Dags are tested and validated with unit tests. With one command, a test docker environment gets built and dags are testing for import errors.

```bash
make airflow-test
```

## List of Pipelines
All data is getting stored cheaply in S3 data lake

- ahwere etl pipeline (practice/test pipeline)
    - takes daily climate data of denver


*Inspired by [andresionek91](https://github.com/andresionek91/airflow-autoscaling-ecs)*