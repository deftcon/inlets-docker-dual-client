# Inlets Dual Client Docker

## Overview
This Docker container contains both the Inlets open source client for tunneling of HTTP/HTTPS traffic and Inlets PRO for tunneling of other TCP ports of your choosing. 

## Prerequisites
1. Docker
2. Outbound Internet access on TCP port 443 (SSL) to the Inlets and Inlets Pro servers running in AWS

## Setup
A file called `.env` contains the parameters that will be passed into the container and to the Inlets client at run time.  The following parameters must be configured:
  
```bash
# Variables for forwarding of HTTP/HTTPS traffic to the target server
TARGET=<FQDN>:<PORT> (ex. somehost.mydomain.com:443)
TOKEN=<Token to authenticate to the Inlets server>
INLETS_SERVER=<FQDN of the Inlets server>
# Variables for forwarding of other TCP ports to the target server
INLETS_PRO_TARGET=<FQDN of target server>
INLETS_PRO_TOKEN=<Token to authenticate to the Inlets PRO server>
INLETS_PRO_SERVER=<FQDN of the Inlets Pro server>
INLETS_PRO_LICENSE=<License file contents>
INLETS_PRO_PORTS=80,8123
LICENSE=<License file contents>
PORTS=<Comma separated list of TCP ports to be tunneled>
```
`TARGET` is the URL of the app being shared. It can be on the same machine as the Inlets client container or on another machine that is reachable from the client machine.  Note that `:port` is required. Make sure the port does not overlap any ports specified in `PORTS`.    

If running the Docker client on a Mac,  Docker runs in a VM and thus for the Inlets container to reach an application shared from the host you must specify a special hostname `host.docker.internal` to reach the host from the container.  As an example,  to share an application running on the Mac host on TCP port 5000,  the .env file setting would be:  `TARGET=http://host.docker.internal` and `PORTS=5000`.

## Running
Make sure the `.env` file is in place and then run the following command:
```
docker-compose up -d
```
The container will come up and begin listening for inbound connections.    

Due to the restart policy for the container, the container will re-initialize upon a reboot of the system.  

## Restarting
If the `.env` file must be modified after the container is already running,  make the modifications and then run the following command:

```
./restart_docker.sh
```
> The above command is a script that runs `docker-compose down` and then `docker-compose up -d`.  It can be run from any directory in the file system, which is useful for using in cron jobs or as a Linux service.

## Logs
First do a `docker ps` to list the running containers to gather the container ID.  
```bash
$ focker ps
CONTAINER ID   IMAGE                COMMAND                  CREATED         STATUS         PORTS                  NAMES
679f71554e84   inlets_dual_client   "/bin/sh -c ./entryp…"   3 seconds ago   Up 2 seconds                          inlets-docker-dual-client_inlets_client_1
```
Then use the CONTAINER ID from the above output in the next command:
```bash
$ docker exec -it 679f /bin/bash
```
You will now be at a bash prompt inside the container.  Use the below commands to view the logs for Inlets and Inlets Pro.

```bash
[root@679f71554e84 /]# cat /var/log/supervisor/inlets.log
Starting Inlets Client (HTTP/HTTPS)
2021/02/25 14:46:43 Starting client - version 3.0.0
2021/02/25 14:46:43 Upstream: inlets-server.lab.tetration.guru => http://host.docker.internal:5000
Welcome to inlets!

Upgrade to inlets PRO for secure, encrypted tunnels and access to fast cloud
and Kubernetes automation.

Find out more at: https://inlets.dev 

time="2021/02/25 14:46:43" level=info msg="Connecting to proxy" url="wss://inlets-server.lab.tetration.guru/tunnel"
```
```bash
[root@679f71554e84 /]# cat /var/log/supervisor/inletspro.log
Starting Inlets Pro Client
2021/02/25 14:46:43 Starting TCP client. Version 0.8.0-dirty - 7d2137f283e67490d64ea68903f7d49b9c9463c3
inlets-pro client. Copyright Alex Ellis, OpenFaaS Ltd 2020
2021/02/25 14:46:43 Licensed to: Mike Madden <mike@deftconsult.io>, expires: 12 day(s)
2021/02/25 14:46:43 Upstream server: host.docker.internal, for ports: 80, 8123
time="2021/02/25 14:46:43" level=info msg="Connecting to proxy" url="wss://inlets-pro.lab.tetration.guru/connect"
[root@679f71554e84 /]#
111
