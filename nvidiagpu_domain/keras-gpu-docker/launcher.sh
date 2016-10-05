#!/bin/bash

# Set up all environment variables here
export PATH=/usr/local/nvidia/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:$LD_LIBRARY_PATH
# Fix cuda libs
if ! [ -e /usr/local/nvidia/lib/libcuda.so ]; then
  ln -s /usr/local/nvidia/lib/libcuda.so.1 /usr/lib/libcuda.so
fi
if ! [ -e /usr/local/nvidia/lib64/libcuda.so ]; then
  ln -s /usr/local/nvidia/lib64/libcuda.so.1 /usr/lib64/libcuda.so
fi
# Update ldconfig cache in case we built without nvidia-docker libs mounted at build time
ldconfig

# Launch application
/usr/bin/python app.py
echo "Application exited with code $?"
exit 0
