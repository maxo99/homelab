#!/bin/bash

# Read version from parent directory
VERSION=$(grep -oP '(?<=version=).*' ../version)

docker build --no-cache -t maxo99/grafana:${VERSION} -t maxo99/grafana:latest  .
# docker push maxo99/grafana:latest

