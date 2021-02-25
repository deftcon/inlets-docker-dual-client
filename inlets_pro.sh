#!/bin/bash

echo "Starting Inlets Pro Client" 
 inlets-pro client --url $PRO_REMOTE \
 --token $PRO_TOKEN \
 --upstream $PRO_UPSTREAM \
 --license $PRO_LICENSE \
 --ports $PRO_PORTS \
 --auto-tls=false