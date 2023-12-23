#!/bin/bash

#docker run -it $(docker build -q .)

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting ...${NC}"

DOCKER_IMAGE=$(docker build -q .) && \
echo "Image created: $DOCKER_IMAGE"
DOCKER_CONTAINER=$(docker create $DOCKER_IMAGE) && \
echo "Container created: $DOCKER_CONTAINER"

docker start -a $DOCKER_CONTAINER
TEST_RESULTS=$?

echo "Removing container $DOCKER_CONTAINER ..." && \
docker rm -f $DOCKER_CONTAINER && \
echo "Removing image $DOCKER_IMAGE ..." && \
docker rmi $DOCKER_IMAGE

[ $TEST_RESULTS -eq 0 ] && echo -e  "${GREEN}Test run completed with no errors." || echo -e "${RED}Tests failed."
