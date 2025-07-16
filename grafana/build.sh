#!/bin/bash

# Read version from parent directory
VERSION=$(grep -oP '(?<=version=).*' ../version)


GRAFANA_DIR=../docker_data/grafana_data

## Copy Provisioning DataSource
mkdir -p ${GRAFANA_DIR}/datasources
cp -r datasources ${GRAFANA_DIR}/datasources

## Copy Provisioning Dashboards
mkdir -p ${GRAFANA_DIR}/dashboards
cp -r dashboards ${GRAFANA_DIR}/dashboards

# # Copy Dashboards from weatherflow collector into Grafana Data
# mkdir -p grafana-data/dashboards/weatherflow_collector
# mkdir -p grafana-data/dashboards/weatherflow_collector2


# # Copy dashboard files from your source
# cp dashboards/weatherflow-collector/*.json grafana-data/dashboards/weatherflow_collector/
# cp dashboards/weatherflow-collector2/*.json grafana-data/dashboards/weatherflow_collector2/


docker build --no-cache -t maxo99/grafana:${VERSION} -t maxo99/grafana:latest  .
# docker push maxo99/grafana:latest

