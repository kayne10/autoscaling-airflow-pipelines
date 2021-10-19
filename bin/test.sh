#/bin/bash

CMD="$1"

case $CMD in
    setup)
        echo "* Setting up test environment... *"
        docker-compose --file docker-compose.test.yml build
        exec docker-compose --file docker-compose.test.yml up -d
        ;;
    exec)
        echo "* Waiting 20s for airflow to start... *"
        sleep 20
        echo "* Executing unit tests... *"
        exec docker exec -it airflow python3 tests/ci.py
        ;;
    exit)
        echo "* Spinning down test environment... *"
        exec docker-compose --file docker-compose.test.yml down
        ;;
    *)
        echo "Not found. Options are [setup,exec,exit]"
        exec "$@"
        ;;
esac