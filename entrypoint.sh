#!/bin/sh
CMD_AIRFLOW_COMMAND_PASSED="$1"

case ${CMD_AIRFLOW_COMMAND_PASSED} in
  webserver)
    airflow initdb
    exec airflow webserver
    ;;
  scheduler)
    exec airflow scheduler
    ;;
  *)
    exec "$@"
    ;;
esac