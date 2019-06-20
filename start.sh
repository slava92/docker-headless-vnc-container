#! /bin/bash

set -euo pipefail

CONT_NAME=centos-xfce-vnc
HUB_NAME=slava92/$CONT_NAME:latest
VOLUME_NAME=vnc-opt

name="--name $CONT_NAME"
hostname="--hostname $CONT_NAME"
ports="-p 5902:5901"
user="--user $(id -u):$(id -g)"
restart="--restart=unless-stopped"
# PRIVILEGED is required to build emacs
if ${PRIVILEGED:-false}; then
    priv='--privileged --pid=host'
fi

# read-only volumes
declare -a ro_volumes=(--volume /etc/resolv.conf:/etc/resolve.conf:ro \
                       --volume "$HOME/.ssh:/headless/.ssh:ro")
# read-write volumes
declare -a rw_volumes=(--volume /private/CENTOS:/private/CENTOS:delegated \
                       --mount "type=volume,source=$VOLUME_NAME,destination=/opt,consistency=delegated")

if docker ps -a | sed 's/  */ /g' | cut -d ' ' -f 2 | grep -E "^$name\$"
then
    echo container $CONT_NAME exists >&2
    exit 1
fi

# DAEMON=-it
docker run ${priv:-} $restart ${DAEMON:- -d} $ports \
       ${ro_volumes[@]} ${rw_volumes[@]} \
       $user $name $hostname $HUB_NAME
