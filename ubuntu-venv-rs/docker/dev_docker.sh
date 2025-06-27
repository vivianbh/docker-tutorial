#!/bin/bash

# Name for my Docker image
IMAGE_NAME="ubuntu-venv-rs"
CONTAINER_NAME="realsense-streamer"

# directory with my custom data or model
## "dirname" would strip the last component from a path 
## "dirname "$PWD"" > given one level above current folder's path 
HOST_DATA_DIR="$(dirname "$PWD")/data"
CONTAINER_DATA_DIR="/workspace/data"

# build image if missing
if [[ "$(sudo docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
	echo "[INFO] Image '$IMAGE_NAME' not found. Building..."
	sudo docker build -t $IMAGE_NAME .
else
	echo "[INFO] Image '$IMAGE_NAME' exists. Skipping build."
fi

# if container is already running
if [[ "$(sudo docker ps -q -f name=^/${CONTAINER_NAME}$)" != "" ]]; then
	echo "[INFO] Container '$CONTAINER_NAME' is already running. Attaching shell..."
	sudo docker exec -it $CONTAINER_NAME bash
	exit 0
fi

# if container exists but is stopped
if [[ "$(sudo docker ps -a -q -f name=^/${CONTAINER_NAME}$)" != "" ]]; then
	echo "[INFO] STarting existing container '$CONTAINER_NAME'..."
	sudo docker start -ai $CONTAINER_NAME
	exit 0
fi

# start new Docker container
xhost +local:root > /dev/null
echo "[INFO] Ruunning new container: '$CONTAINER_NAME'..."
sudo docker run -it \
    --name $CONTAINER_NAME \
    --device=/dev/bus/usb \
    --group-add video \
    --env="DISPLAY" \
    --privileged \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$HOST_DATA_DIR:$CONTAINER_DATA_DIR" \
    $IMAGE_NAME \
    bash
