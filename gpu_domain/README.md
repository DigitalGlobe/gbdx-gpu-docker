# gbdx-gpu-docker
Building GPU docker containers for GBDX with support for Caffe and OpenCV from scratch.

The current version of GPU containers on DigitalGlobe's Geospatial Big Data platform requires specific drivers, namely 346.46.
The centos7 and ubuntu directories will help you to create base containers with those drivers installed and from there help 
you build and install caffe and its dependencies.
The ubuntu build is based on 14.04 and pulls most dependencies in as pre-built packages. The centos7 version builds most of the 
dependencies from scratch so you have a lot more control of versioning and compilation options.

## Building the container

Requirements:
Have docker and ideally nvidia drivers installed on your build machine ( the latter is only required for local testing but recommended ).

1. Choose your base image, centos7 or ubuntu
2. run "sudo bash build.sh"

For example for the centos7 build this will create three containers for you

`BASEIMAGE="gbdx-centos7-cuda-7.0-346.46"`

`DEVIMAGE="gbdx-centos7-cuda-7.0-346.46-dev"`

`RUNTIMEIMAGE="gbdx-caffe-centos7"`

The baseimage contains just the required drivers and cuda 7.0. The dev image adds all packages required to build caffe to that
and last but not least the runtime image will contain the fully built and installed caffe runtime.

## Testing the container

### Locally

You can test the container locally by running it as indicated in the "interactive.sh" script. You must make however that the driver
version of the host you are running on matches the driver in the container. Often it is simpler to change the container driver than
to mess with your host drivers, so you might want to build a test container based on your installed nvidia drivers. In order to do so
edit the build/build_baseimage.sh script to adjust the driver version and make sure the appropriate driver package is present.

### On the GBDX platform

The testapp directory contains a very simple example on how to run the container on the platform and includes sample task and 
workflow descriptions. Please refer to the [GBDX platform API docs](https://gbdxdocs.digitalglobe.com/docs/task-and-workflow-course)
for details.
