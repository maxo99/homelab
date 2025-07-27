#!/bin/bash


# WeatherFlow Collector
cp .env weatherflow-collector/.env
cd weatherflow-collector
bash build.sh
cd ..
# rm -f weatherflow-collector/.env


# Grafana
cp .env grafana/.env
cd grafana
bash build.sh
cd ..
# rm -f grafana/.env

