#!/bin/bash

set -euo pipefail

if ! command -v podman >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y podman
fi

HOST_SITE_DIR="$HOME/site2"
HOST_LOG_DIR="$HOME/pod_logs"
mkdir -p "$HOST_SITE_DIR" "$HOST_LOG_DIR"

cp -r "$(dirname "$0")/../site2/"* "$HOST_SITE_DIR"/

podman volume create webcontent || true
podman volume create weblogs || true 

podman run -d --name apache-pod \
  -p 8080:80 \
  -v "$HOST_SITE_DIR":/usr/local/apache2/htdocs:Z \
  -v "$HOST_LOG_DIR":/usr/local/apache2/logs:Z \
  docker.io/library/httpd:alpine

echo "Apache container started on port 8080."
echo "Test: curl http://localhost:8080 or http://<EC2_PUBLIC_IP>:8080"
