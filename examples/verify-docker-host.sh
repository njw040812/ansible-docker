#!/usr/bin/env bash
# Run this on the target Docker host after ansible-playbook.
set -euo pipefail

docker info > /dev/null
docker compose version > /dev/null
python3 -m json.tool /etc/docker/daemon.json > /dev/null

echo "docker: $(docker info --format '{{.ServerVersion}}')"
echo "logging driver: $(docker info --format '{{.LoggingDriver}}')"
echo "live restore: $(docker info --format '{{.LiveRestoreEnabled}}')"
echo "docker service: $(systemctl is-active docker)"
echo "cleanup cron: $(test -f /etc/cron.d/docker-image-cleanup && echo present || echo missing)"
