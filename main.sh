#!/bin/bash

# Set up aliases
cat > "/home/subbots/.bashrc" <<EOF
start() {
sudo docker run -it --net=host -v /dev:/dev --privileged "$1" bash
}
connect() {
sudo docker exec -it "$1" bash
}
EOF

# Pull docker image 

# Install auto start script (but do not enable or run it)
set -euo pipefail

SERVICE_NAME="steelhead-autolaunch"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
LAUNCH_SCRIPT="/home/subbots/fishwrap/autostart.sh"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run as root: sudo $0"
  exit 1
fi

cat > "${SERVICE_FILE}" <<EOF
[Unit]
Description=Steelhead ROS on-boot launch
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
ExecStart=${LAUNCH_SCRIPT}
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

echo "Created ${SERVICE_FILE}"
echo "Reloaded systemd"


# Install lichtblick with our plugins 


# Set up OliveTin
