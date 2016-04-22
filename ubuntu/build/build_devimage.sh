#!/bin/bash
apt-get -y update
apt-get -y upgrade
apt-get -y install build-essential
apt-get -y install cmake wget libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev \
  libhdf5-serial-dev protobuf-compiler gfortran libjpeg62 libfreeimage-dev libatlas-base-dev git \
  python-dev python-pip libgoogle-glog-dev libbz2-dev libxml2-dev libxslt-dev libffi-dev libssl-dev \
  libgflags-dev liblmdb-dev python-yaml python-numpy

# cleanup
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
