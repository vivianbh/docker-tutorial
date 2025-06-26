#!/bin/bash

# Name for my Docker image
IMAGE_NAME="yolov7-python310-jupyter"
CONTAINER_NAME="yolov7-container"

# directory with my custom data or model
## "dirname" would strip the last component from a path 
## "dirname "$PWD"" > given one level above current folder's path 
HOST_DATA_DIR="$(dirname "$PWD")/data"
CONTAINER_DATA_DIR="/workspace/data"

LOGS_DIR="$HOST_DATA_DIR/logs"
mkdir -p "$LOGS_DIR"

# build Docker image
echo "Building Docker image: $IMAGE_NAME"
sudo docker build -t $IMAGE_NAME .

# run Docker container in detached mode so can exec into it
echo "Ruunning Docker container with Jupyter Notebook"
sudo docker run -it -d \
    --name $CONTAINER_NAME \
    -v "$HOST_DATA_DIR:$CONTAINER_DATA_DIR" \
    -p 8888:8888 \
    $IMAGE_NAME

# follow logs and save to file (non-blocking)
## "&>": redirect both stdout and stderr to the log file
## "&": make the logging run in the background so the script doesn't block
docker logs -f $CONTAINER_NAME &> "$LOGS_DIR/runtime.log" &
