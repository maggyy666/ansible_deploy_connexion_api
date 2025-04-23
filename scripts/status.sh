#!/bin/bash
echo "----------------------------------------"
echo "Checking Docker container status..."

docker ps --filter "name=connexion-api" --filter "name=opensearch"

echo
echo "----------------------------------------"

echo "Container Health Status:"

docker inspect -f '{{Name}} - Health: {{ .State.Health.Status }}' $(docker ps -q) 2>/dev/null | grep -v "Health: <nil>" || echo "No healthchecks defined."

echo
echo "----------------------------------------"

echo "Memory and CPU Usage:"

docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" 2>/dev/null || echo "No containers running."

echo

echo "Status check complete."
echo "----------------------------------------"