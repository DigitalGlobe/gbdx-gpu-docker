#!/bin/bash
FINALIMAGE="pdlimp/private:gputest"
# Run docker build to construct final image with application
docker rmi $FINALIMAGE
docker build -t $FINALIMAGE docker
