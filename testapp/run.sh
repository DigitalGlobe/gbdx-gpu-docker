docker run \
--device=/dev/nvidiactl \
--device=/dev/nvidia0 \
--volume-driver=nvidia-docker \
-v /mnt/work:/mnt/work \
--rm \
pdlimp/private:gputest
