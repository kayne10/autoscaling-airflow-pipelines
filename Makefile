# ORIGINAL SOURCE: https://github.com/andresionek91/airflow-autoscaling-ecs

install-requirements:
	pip install -r config/requirements.txt

check-env-setup:
	python -c 'from utils import check_environment_variables;  check_environment_variables()';

cloudformation-validate: install-requirements check-env-setup
	python -c 'from deploy_aws import validate_templates;  validate_templates()';

infra-deploy: cloudformation-validate
	python -c 'from deploy_aws import create_or_update_stacks;  create_or_update_stacks(is_foundation=True)';

push-to-ecr:
	bin/deploy_docker.sh build $(tag)
	bin/deploy_docker.sh tag $(tag)
	bin/deploy_docker.sh push $(tag)

airflow-deploy: infra-deploy
	python -c 'from deploy_aws import create_or_update_stacks;  create_or_update_stacks(is_foundation=False)';
	python -c 'from deploy_aws import log_outputs;  log_outputs()';

airflow-push-image: push-to-ecr
	python -c 'from deploy_aws import restart_airflow_ecs;  restart_airflow_ecs()';

airflow-destroy:
	python -c 'from deploy_aws import destroy_stacks;  destroy_stacks()';

airflow-local:
	export FERNET_KEY=${FERNET_KEY}
	docker-compose up --build

airflow-test:
	bin/test.sh setup
	bin/test.sh exec
	bin/test.sh exit