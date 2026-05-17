#!/bin/bash
set -euo pipefail

APP_NAME="devops-app"
IMAGE_NAME="devops-app:latest"
HOST_PORT=3000
HEALTH_URL="http://localhost:${HOST_PORT}/health"
LOG_FILE="./deploy.log"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

log "Starting deployment..."
docker build -t $IMAGE_NAME . || { log "ERROR: Build failed!"; exit 1; }

if docker ps -a --format '{{.Names}}' | grep -q "^${APP_NAME}$"; then
  log "Stopping old container..."
  docker stop $APP_NAME && docker rm $APP_NAME
fi

log "Starting new container..."
docker run -d --name $APP_NAME --restart unless-stopped -p $HOST_PORT:3000 $IMAGE_NAME

sleep 5
MAX_RETRIES=5; COUNT=0
until curl -sf "$HEALTH_URL" > /dev/null; do
  COUNT=$((COUNT+1))
  [ $COUNT -ge $MAX_RETRIES ] && { log "ERROR: Health check failed!"; docker logs $APP_NAME; exit 1; }
  log "Retry $COUNT/$MAX_RETRIES..."; sleep 3
done

log " Deployment successful!"
docker image prune -f
