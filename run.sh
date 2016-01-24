#!/bin/bash -e

# A script for running this image at the iegget deployment. See the README file for details.
# Moreover, it uses tozd/docker-hosts for service discovery and mounts its volume (/srv/var/hosts).

mkdir -p /srv/var/log/sympa
mkdir -p /srv/sympa/etc/includes
mkdir -p /srv/sympa/etc/shared
mkdir -p /srv/sympa/spool
mkdir -p /srv/sympa/nullmailer
mkdir -p /srv/sympa/data

docker stop sympa || true
sleep 1
docker rm sympa || true
sleep 1
docker run --detach=true --restart=always --name sympa --hostname sympa \
  --env SET_REAL_IP_FROM=172.17.0.0/16 \
  --env REMOTES=mail \
  --volume /srv/var/hosts:/etc/hosts:ro \
  --volume /srv/var/log/sympa:/var/log/sympa \
  --volume /srv/sympa/etc/includes:/etc/sympa/includes \
  --volume /srv/sympa/etc/shared:/etc/sympa/shared \
  --volume /srv/sympa/spool:/var/spool/sympa \
  --volume /srv/sympa/nullmailer:/var/spool/nullmailer \
  --volume /srv/sympa/data:/var/lib/sympa \
  iverasp/sympa
