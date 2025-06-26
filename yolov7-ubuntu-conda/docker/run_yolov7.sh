#!/bin/bash

# Name for my Docker image
IMAGE_NAME="yolov7-ubuntu-conda"
CONTAINER_NAME="yolov7-conda"

# directory with my custom data or model
## "dirname" would strip the last component from a path 
## "dirname "$PWD"" > given one level above current folder's path 
HOST_DATA_DIR="$(dirname "$PWD")/data"
CONTAINER_DATA_DIR="/workspace/data"

# build Docker image
echo "Building Docker image: $IMAGE_NAME"
sudo docker build -t $IMAGE_NAME .

# run Docker container
echo "Ruunning Docker container from image: $IMAGE_NAME"
sudo docker run -it --rm \
    --name $CONTAINER_NAME \
    -p 8888:8888 \
    -v "$HOST_DATA_DIR:$CONTAINER_DATA_DIR" \
    $IMAGE_NAME
