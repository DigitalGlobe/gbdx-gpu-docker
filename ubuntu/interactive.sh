docker run \
   --device=/dev/nvidiactl \
   --device=/dev/nvidia-uvm \
   --device=/dev/nvidia0 \
   --volume-driver=nvidia-docker \
   -v /mnt/work:/mnt/work \
   -v `pwd`/build:/build \
   --rm -it \
   caffe-ubuntu /bin/bash
