#!/bin/bash -eux
set -o pipefail

docker build -t bodypix bodypix/

docker build -t fakecam fakecam/
