
```
sudo mkdir -p /opt/portainer
sudo nano /opt/portainer/docker-compose.yml
```

`sudo nano /etc/systemd/system/portainer.service`

```
[Unit]
Description=Portainer Docker Management
Requires=docker.service
After=docker.service
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/portainer
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```