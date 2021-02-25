#!/bin/bash

echo "Starting Inlets Client (HTTP/HTTPS)"
inlets client --url $REMOTE \
 --token $TOKEN \
 --upstream $UPSTREAM