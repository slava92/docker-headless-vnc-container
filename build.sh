#! /bin/sh

set -euo pipefail

CONT_NAME=centos-xfce-vnc
HUB_NAME=slava92/$CONT_NAME:latest
# DEBUG=--debug
# FROM_SCRATCH='--no-cache'

docker ${DEBUG:-} build \
       --tag $HUB_NAME \
       ${FROM_SCRATCH:-} .
