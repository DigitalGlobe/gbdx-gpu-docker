#!/bin/bash
yum -y update
yum -y groupinstall "Development Tools"
yum -y install tbb-devel libjpeg-turbo-devel libpng-devel libtiff-devel jasper-devel \
      libcurl-devel openssl-devel freetype-devel readline-devel bzip2-devel \
      wget which cmake
rm -rf /var/cache/yum/*
ldconfig
