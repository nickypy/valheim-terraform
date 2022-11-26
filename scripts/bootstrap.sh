#!/bin/bash
HOST=$1
SSH_HOST=root@$HOST

ssh "$SSH_HOST" echo "OK"
while test $? -ne 0
do
   echo "Retrying ssh in 5s..."
   sleep 5
   ssh "$SSH_HOST" echo "OK"
done

set -eo pipefail

scp -r ./server "$SSH_HOST:~"
ssh "$SSH_HOST" docker compose -f ./server/docker-compose.yml up -d --wait
