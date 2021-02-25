#!/bin/bash
docker-compose --project-directory `dirname "$0"` -f `dirname "$0"`/docker-compose.yml down
docker-compose --project-directory `dirname "$0"` -f `dirname "$0"`/docker-compose.yml up -d