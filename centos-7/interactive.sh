/sbin/modprobe nvidia-uvm

if [ "$?" -eq 0 ]; then
  if ! [ -e /dev/nvidia-uvm ]; then
    # Find out the major device number used by the nvidia-uvm driver
    D=`grep nvidia-uvm /proc/devices | awk '{print $1}'`
    mknod -m 666 /dev/nvidia-uvm c $D 0
  fi 
else
 exit 1
fi

docker run \
   --device=/dev/nvidiactl \
   --device=/dev/nvidia-uvm \
   --device=/dev/nvidia0 \
   -v `pwd`/build:/build \
   --rm -it \
   gbdx-caffe-centos7 /bin/bash
