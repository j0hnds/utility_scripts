#!/bin/sh


if [ $# -lt 1 ]
then
  echo "Must specify the server name"
  exit 1
fi

SERVER=$1

TARBALL_NAME=${HOSTNAME}_${SERVER}_abaqis_config.tar.bz2

# Create a tar-ball of the stuff we want
tar jcf ${TARBALL_NAME} /etc/abaqis /var/www/${SERVER}/shared/config /var/www/${SERVER}/shared/scripts
