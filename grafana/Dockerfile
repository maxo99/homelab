FROM grafana/grafana:8.0.4

ENV GF_ANALYTICS_REPORTING_ENABLED=FALSE \
    GF_AUTH_ANONYMOUS_ENABLED=true \
    GF_AUTH_ANONYMOUS_ORG_ROLE=Viewer \
    GF_AUTH_BASIC_ENABLED=true \
    GF_AUTH_DISABLE_LOGIN_FORM=false \
    GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/var/lib/grafana/dashboards/weatherflow_collector/weatherflow_collector-historical_local-udp-influxdb.json \
    GF_PATHS_PLUGINS="/var/lib/grafana-plugins" \
    GF_SECURITY_ADMIN_PASSWORD=admin \
    GF_SECURITY_ADMIN_USER=admin \
    GF_SECURITY_ALLOW_EMBEDDING=true \
    GF_SECURITY_DISABLE_GRAVATAR=true \
    GF_USERS_ALLOW_SIGN_UP=false 
    # GF_PATHS_PROVISIONING=/etc/grafana/provisioning

USER root

RUN grafana-cli --pluginsDir "${GF_PATHS_PLUGINS}" plugins install grafana-worldmap-panel 0.3.3

USER grafana


# # Copy DataSource
# COPY provisioning/datasources/influxdb-weatherflow.yml /etc/grafana/provisioning/datasources

# RUN mkdir /var/lib/grafana/dashboards

# COPY provisioning/dashboards/weatherflow-collector.yml /etc/grafana/provisioning/dashboards
# COPY provisioning/dashboards/weatherflow-collector2.yml /etc/grafana/provisioning/dashboards

# COPY dashboards/weatherflow-collector/*.json /var/lib/grafana/dashboards/weatherflow_collector/
# COPY dashboards/weatherflow-collector2/*.json /var/lib/grafana/dashboards/weatherflow_collector2/

EXPOSE 3000
