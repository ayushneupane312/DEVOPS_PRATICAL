#!/bin/bash
CONTAINER_NAME=${1:-devops-app}
echo "============================================"
echo "  CONTAINER DEBUG: $CONTAINER_NAME"
echo "============================================"
echo ""
echo "STEP 1: Container Status"
docker ps -a --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "STEP 2: Last 30 log lines"
docker logs "$CONTAINER_NAME" --tail 30 2>&1 || echo "No logs available"
echo ""
echo "STEP 3: Exit Code"
EXIT_CODE=$(docker inspect "$CONTAINER_NAME" --format='{{.State.ExitCode}}' 2>/dev/null || echo "N/A")
echo "Exit Code: $EXIT_CODE"
case $EXIT_CODE in
  0)   echo "Clean exit" ;;
  1)   echo "App error - check logs" ;;
  137) echo "OOM Killed - increase memory limit" ;;
  126) echo "Permission denied on command" ;;
  127) echo "Command not found in container" ;;
  *)   echo "Unknown error" ;;
esac
echo ""
echo "STEP 4: Resource Usage"
docker stats "$CONTAINER_NAME" --no-stream 2>/dev/null || echo "Container not running"
echo ""
echo "STEP 5: Proposed Fixes"
docker logs "$CONTAINER_NAME" 2>&1 | grep -qi "ECONNREFUSED" && echo "FIX: DB not reachable - check network"
docker logs "$CONTAINER_NAME" 2>&1 | grep -qi "permission denied" && echo "FIX: Check USER in Dockerfile"
docker logs "$CONTAINER_NAME" 2>&1 | grep -qi "cannot find module" && echo "FIX: Rebuild image with npm install"
docker logs "$CONTAINER_NAME" 2>&1 | grep -qi "killed" && echo "FIX: OOM - add --memory=512m flag"
echo "============================================"
