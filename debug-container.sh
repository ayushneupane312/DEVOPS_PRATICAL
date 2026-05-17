#!/bin/bash
echo "=== Build the image ==="
docker build -t devops-app:latest .
echo "=== Run the container ==="
docker run -d -p 3000:3000 --name devops-app devops-app:latest
echo "=== Check status ==="
docker ps -a | grep devops-app
echo "=== View logs ==="
docker logs devops-app
echo "=== Health check ==="
sleep 3
curl -s http://localhost:3000/health || echo "Health check failed"
echo "=== Manual Debug Commands ==="
echo "docker logs devops-app --tail 50 --follow"
echo "docker exec -it devops-app /bin/sh"
echo "docker inspect devops-app"
echo "docker stats devops-app --no-stream"
