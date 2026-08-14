#!/usr/bin/env bash
set -euo pipefail

if systemctl is-active --quiet go-microservice.service; then
  echo "Stopping go-microservice..."
  systemctl stop go-microservice.service
else
  echo "go-microservice not running, skipping stop."
fi
