# Default recipe to show available commands
default:
    @just --list


# Variables
GRAFANA_CONTAINER := "maxo99/grafana"
GRAFANA_SRC := "./grafana"
DOCKER_DATA := "./docker_data"
GRAFANA_DATA := "${DOCKER_DATA}/grafana"

get-version:
   echo `grep -oP '(?<=version=).*' ./version`

build-grafana: get-version
    #!/usr/bin/env bash
    set -euxo pipefail
    VERSION=`just get-version`
    echo "Building Grafana container with version: ${VERSION}"
    cd grafana && docker build -t {{GRAFANA_CONTAINER}}:${VERSION} -t {{GRAFANA_CONTAINER}}:latest .

build-restart-grafana:
    @echo "Building and restarting Grafana container..."
    just build-grafana
    docker compose up -d --force-recreate {{GRAFANA_CONTAINER}}
    @echo "Grafana container restarted successfully"




#Copy dashboard files to running Grafana container
update-dashboards:
    @echo "Updating dashboards in running container..."
    docker cp {{GRAFANA_SRC}}/dashboards/. {{GRAFANA_CONTAINER}}:/var/lib/grafana/dashboards/
    @echo "Dashboards updated successfully"


# Copy provisioning files to running Grafana container
update-provisioning:
    @echo "Updating provisioning files in running container..."
    docker cp {{GRAFANA_SRC}}/provisioning/dashboards/weatherflow-collector.yml {{GRAFANA_CONTAINER}}:/etc/grafana/provisioning/dashboards/
    docker cp {{GRAFANA_SRC}}/provisioning/dashboards/weatherflow-collector2.yml {{GRAFANA_CONTAINER}}:/etc/grafana/provisioning/dashboards/
    docker cp {{GRAFANA_SRC}}/provisioning/datasources/influxdb-weatherflow.yml {{GRAFANA_CONTAINER}}:/etc/grafana/provisioning/datasources/
    @echo "Provisioning files updated successfully"

# Update all Grafana files (dashboards + provisioning)
# update-grafana: update-provisioning update-dashboards
#     @echo "Reloading Grafana configuration..."
#     docker exec {{GRAFANA_CONTAINER}} kill -HUP 1
#     @echo "Grafana files updated and configuration reloaded"

# Create the weatherflow_collector2 directory structure
create-collector2-dirs:
    @echo "Creating weatherflow_collector2 directory structure..."
    docker exec {{GRAFANA_CONTAINER}} mkdir -p /var/lib/grafana/dashboards/weatherflow_collector2
    @echo "Directory structure created"

# Check if files exist in the container
check-grafana-files:
    @echo "Checking Grafana files in container..."
    @echo "Dashboard directories:"
    docker exec {{GRAFANA_CONTAINER}} ls -la /var/lib/grafana/dashboards/ || echo "Dashboards directory not found"
    @echo "\nProvisioning files:"
    docker exec {{GRAFANA_CONTAINER}} ls -la /etc/grafana/provisioning/dashboards/ || echo "Provisioning directory not found"

# Clean up and recreate Grafana with fresh volume
recreate-grafana-clean:
    @echo "Stopping and removing Grafana container and volume..."
    docker compose stop maxo99-grafana
    docker compose rm -f maxo99-grafana
    docker volume rm homelab_maxo99-grafana-data || true
    @echo "Rebuilding and starting Grafana..."
    just build-grafana

# Tail Grafana logs
logs CONTAINER:
    docker compose logs -f {{CONTAINER}}

# Quick development workflow: update files and check logs
# dev-update: update-grafana
#     @echo "Files updated. Checking logs..."
#     sleep 2
#     docker compose logs --tail=20 maxo99-grafana