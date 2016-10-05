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

PARAMS=`curl -s http://localhost:3476/v1.0/docker/cli`

docker run $PARAMS \
   -v `pwd`/build:/build \
   -v /mnt/work:/mnt/work \
   --rm  \
   pdlimp/private:cudatest 
