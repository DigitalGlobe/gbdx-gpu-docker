#!/bin/bash
echo $@
uname -a
# Where are we running from
echo "Runtime location"
pwd

echo "Disk space ---------------------------------------------------------------"
df -h

echo "NVIDIA host driver ---------------------------------------------------------------"
# Check NVIDIA driver
cat /proc/driver/nvidia/version
find /proc/driver/nvidia/gpus -name information -exec cat {} \;

echo "NVIDIA SMI ---------------------------------------------------------------"
/usr/bin/nvidia-smi
/usr/bin/nvidia-smi -q
echo "Driver libraries in container"
ls -al /usr/lib/libnv*

echo "Kernel Modules ---------------------------------------------------------------"
/sbin/lsmod

echo "Devices ---------------------------------------------------------------"
ls -al /dev/

echo "CPU status ---------------------------------------------------------------"
cat /proc/cpuinfo

echo "Memory status ---------------------------------------------------------------"
free -m
cat /proc/meminfo

echo "Input Data ---------------------------------------------------------------"
ls -alR /mnt/work/
exit 0
