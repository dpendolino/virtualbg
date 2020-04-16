#!/bin/bash -eux
set -o pipefail

# create a network
docker network ls | grep fakecam &> /dev/null
if [ $? -ne 0 ]; then
  docker network create --driver bridge fakecam
fi
# start the bodypix app
docker run -d \
  --name=bodypix \
  --network=fakecam \
  --gpus=all --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 \
  bodypix

sleep 30

# start the camera, note that we need to pass through video devices,
# and we want our user ID and group to have permission to them
# you may need to `sudo groupadd $USER video`
docker run -d \
  --name=fakecam \
  --network=fakecam \
  -p 8080:8080 \
  --gpus=all \
  -u "$(id -u):$(getent group video | cut -d: -f3)" \
  $(sudo find /dev -name 'video*' -printf "--device %p ") \
  fakecam
