#!/bin/bash
apt-get -y update
apt-get -y upgrade
apt-get -y install wget 

if ! [ -f cuda_7.0.28_linux.run ]; then
  wget http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_linux.run
fi
if ! [ -f cuda-install/cuda-linux64-rel-7.0.28-19326674.run ]; then
  /bin/bash cuda_7.0.28_linux.run -extract /build/cuda-install/
fi
# Install Nvidia driver
sh cuda-install/NVIDIA-Linux-x86_64-346.46.run -s -N --no-kernel-module
# /bin/bash NVIDIA-Linux-x86_64-361.42.run -s -N --no-kernel-module
# Install CUDA
./cuda-install/cuda-linux64-rel-7.0.28-19326674.run -noprompt
echo "/usr/local/cuda/lib" >> /etc/ld.so.conf.d/cuda.conf
echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf
ldconfig
echo 'export PATH=/usr/local/cuda/bin:$PATH' > /etc/profile.d/cuda.sh
echo 'export PATH=/usr/local/cuda/bin:$PATH' >> /etc/bash.bashrc
chmod +x /etc/profile.d/cuda.sh
# Install CUDNN
if ! [ -f cudnn-7.0-linux-x64-v4.0-rc.tgz ]; then
  wget http://developer.download.nvidia.com/compute/redist/cudnn/v4/cudnn-7.0-linux-x64-v4.0-rc.tgz
fi
if [ -d /usr/local/cuda-7.0 ]; then
  cd /usr/local/cuda-7.0
  tar -x -v --strip-components 1 -f /build/cudnn-7.0-linux-x64-v4.0-rc.tgz
  cd /build
fi
# clean up cuda SDK, remove everything we won't need
find /usr/local/cuda-7.0 -name "*.a" -exec rm {} \;
rm -rf /usr/local/cuda-7.0/doc
rm -rf /usr/local/cuda-7.0/extras
rm -rf /usr/local/cuda-7.0/jre
rm -rf /usr/local/cuda-7.0/libnsight
rm -rf /usr/local/cuda-7.0/libnvvp
rm -rf /usr/local/cuda-7.0/tools
# cleanup
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

