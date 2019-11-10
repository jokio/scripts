#!/bin/sh
REGION=$1
CONTAINER=$2

echo "REGION=$REGION"
echo "CONTAINER=$CONTAINER"

rootFolderName=jokio-docker

if [ -z "$CONTAINER" ]
then
# Pre-requirement: check and install pip & docker-compose
echo "Prerequirement dependency install..."
echo "+++++++++++++++++++++++++++++++++++++"
apt install -y python-pip && pip install docker-compose
echo "+++++++++++++++++++++++++++++++++++++"
fi

# Create neessary folders
if [ -e /cluster ]; then
	echo "/cluster folder already exists, skipped creating";
else
	mkdir /cluster
fi

if [ -e /cluster/acme ]; then
	echo "/cluster/acme folder already exists, skipped creating";
else
	mkdir /cluster/acme
fi


# Start deployment
cd /tmp
rm -fr $rootFolderName

# Clone repository
git clone git@github.com:playerx/jok-docker.git $rootFolderName

cd $rootFolderName

# Copy files
if [ -e /cluster/traefik.toml ]; then
	rm /cluster/traefik.toml
fi

cp ./traefik.toml /cluster/


echo "REGION=$REGION" >> ./.env

# Pull Images & Up them all
docker-compose pull $CONTAINER
docker-compose up -d $CONTAINER

# Clean unused images
docker image prune -f

# Cleanup
cd ..
# rm -fr $rootFolderName
