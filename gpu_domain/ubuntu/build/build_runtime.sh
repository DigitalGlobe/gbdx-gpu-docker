#!/bin/bash
INSTALL_HOME=/opt/caffe
USE_CUDNN=1
BUILD_THREADS=8

# Install python dependencies
pip install Pillow==2.9.0

if ${BUILD_CAFFE}; then
  if ! [ -f NVcaffe-0.14.2.tar.gz ]; then
    wget -O NVcaffe-0.14.2.tar.gz https://github.com/NVIDIA/caffe/archive/v0.14.2.tar.gz
  fi
  if ! [ -d caffe-0.14.2 ]; then
    tar xvfz NVcaffe-0.14.2.tar.gz
    #git clone https://github.com/NVIDIA/caffe.git
    #git clone https://github.com/BVLC/caffe.git
  fi
  cd caffe-0.14.2
  # Install python dependencies
  cat python/requirements.txt | xargs -L 1 pip install

  if [ -d build ]; then
    rm -rf build
  fi
  mkdir build
  cd build
  cmake -DBLAS=atlas \
        -DUSE_CUDNN=${USE_CUDNN} \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_HOME} \
        ..
  make all -j ${BUILD_THREADS}
  #make runtest -j ${BUILD_THREADS}
  make install
fi

ln /dev/null /dev/raw1394
echo "/opt/caffe/lib" >> /etc/ld.so.conf.d/caffe.conf
echo "/opt/caffe/lib64" >> /etc/ld.so.conf.d/caffe.conf
ldconfig
echo 'export PATH=/opt/caffe/bin:$PATH' > /etc/profile.d/caffe.sh
echo 'export PYTHONPATH=/opt/caffe/python' >> /etc/profile.d/caffe.sh
chmod +x /etc/profile.d/caffe.sh
echo 'export PATH=/opt/caffe/bin:$PATH' >> /etc/bash.bashrc
echo 'export PYTHONPATH=/opt/caffe/python' >> /etc/bash.bashrc

# cleanup
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
