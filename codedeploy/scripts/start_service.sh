#!/usr/bin/env bash
set -euo pipefail

echo "Starting go-microservice..."
systemctl start go-microservice.service
systemctl status go-microservice.service --no-pager
