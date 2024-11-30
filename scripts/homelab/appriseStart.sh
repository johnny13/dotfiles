#!/usr/bin/env bash

echo -e "\nRunning Apprise...\n"


docker run --name apprise \
   -p 8000:8000 \
   -e PUID=$(id -u) \
   -e PGID=$(id -g) \
   -v /home/derek/apprise/config:/config \
   -v /home/derek/apprise/plugin:/plugin \
   -v /home/derek/apprise/attach:/attach \
   -e APPRISE_STATEFUL_MODE=simple \
   -e APPRISE_WORKER_COUNT=1 \
   -d caronc/apprise:latest