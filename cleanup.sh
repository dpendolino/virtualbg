#!/bin/bash -eux
set -o pipefail

docker rm -f bodypix fakecam

docker network ls | grep fakecam &> /dev/null
if [ $? -eq 0 ]; then
  docker network rm fakecam
fi

