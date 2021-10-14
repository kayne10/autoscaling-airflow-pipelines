#!/bin/sh

CMD="$1"
TAG="$2"
REPO="airflow-${ENVIRONMENT}"

connect_to_ecr () {
    echo "Connecting to ECR"
    aws ecr get-login-password --region us-west-2 | \
    docker login --username AWS --password-stdin "${ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com"
}

validate_tag () {
    if [[ -z "${TAG}" || "${TAG}" == ""  ]] 
    then
        echo "No tag name specified for command '${CMD}'"
        echo "${CMD} usage: ./deploy_docker.sh ${CMD} <tag_name>"
        exit 1
    else
        echo "Detected image tag of: ${TAG}"
    fi
}

add_latest_tag () {
   docker tag "${REPO}:${TAG}" "${ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/${REPO}:latest"
   docker push "${ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/${REPO}:latest"
}

case ${CMD} in
    build)
        validate_tag
        connect_to_ecr
        echo "Building docker image ${REPO}:${TAG}"
        exec docker build -t ${REPO}:${TAG} \
        --build-arg AWHERE_TOKEN_URL=$AWHERE_TOKEN_URL \
        --build-arg AWHERE_ENCODED_KEY=$AWHERE_ENCODED_KEY .
        ;;
    tag)
        validate_tag
        echo "Tagging ecr repo: ${REPO} with tag: ${TAG} and latest"
        exec docker tag "${REPO}:${TAG}" "${ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/${REPO}:${TAG}"
        ;;
    push)
        validate_tag
        echo "Pushing ecr repo: ${REPO} with tag: ${TAG}"
        docker push "${ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/${REPO}:${TAG}"
        add_latest_tag
        ;;
    pull)
        validate_tag
        connect_to_ecr
        exec docker pull "${ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/${REPO}:${TAG}"
        ;;
    *)
        echo "No valid command option used"
        echo "Options: [build, tag, push, pull]"
        exec "$@"
        ;;
esac
