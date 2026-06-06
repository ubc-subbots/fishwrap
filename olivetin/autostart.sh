#!/bin/bash
set -euo pipefail

NAME="steelhead-sbc"
IMAGE="ghcr.io/ubc-subbots/steelhead-sbc"

if ! sudo docker ps -a --format '{{.Names}}' | grep -qx "$NAME"; then
  sudo docker run -d \
    --name "$NAME" \
    --net=host \
    -v /dev:/dev \
    --privileged \
    "$IMAGE" \
    tail -f /dev/null
elif ! sudo docker ps --format '{{.Names}}' | grep -qx "$NAME"; then
  sudo docker start "$NAME"
fi

for i in $(seq 1 20); do
  if sudo docker ps --format '{{.Names}}' | grep -qx "$NAME"; then
    break
  fi
  sleep 1
done

sudo docker exec -d "$NAME" bash -lc '
  source /root/steelhead/install/setup.bash &&
  ros2 launch steelhead_bringup pool_test_hardcode_launch.py
'