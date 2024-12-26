#!/bin/bash

IMAGE_NAME="lastfm-swift-tests"

docker build -t $IMAGE_NAME . && \
docker run --rm $IMAGE_NAME
