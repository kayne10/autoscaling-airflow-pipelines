FROM python:3.7-stretch

# Airflow
ENV AIRFLOW_HOME=/usr/local/airflow

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

ADD . /usr/local/airflow

WORKDIR "/usr/local/airflow"

RUN pip3 install -r requirements.txt

ENV PYTHONPATH=$PYTHONPATH:$AIRFLOW_HOME

EXPOSE 8080

RUN chmod u+x entrypoint.sh
RUN chmod +x myairflow/scripts/etl/*.py

ENTRYPOINT ["/usr/local/airflow/entrypoint.sh"]
CMD ["webserver"]