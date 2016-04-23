#!/bin/bash
echo $@
uname -a
echo
# Where are we running from
echo "Runtime location"
pwd
echo
echo "Disk space -----------------------------------------------------------------------"
df -h
echo
echo "NVIDIA host driver ---------------------------------------------------------------"
# Check NVIDIA driver
cat /proc/driver/nvidia/version
find /proc/driver/nvidia/gpus -name information -exec cat {} \;
echo
echo "NVIDIA SMI -----------------------------------------------------------------------"
/usr/bin/nvidia-smi
/usr/bin/nvidia-smi -q
echo "NVIDIA deviceQuery ---------------------------------------------------------------"
chmod +x deviceQuery
./deviceQuery
echo
echo "NVIDIA Driver libraries in container ---------------------------------------------"
ls -al /usr/lib/libnv*
echo
echo "Kernel Modules -------------------------------------------------------------------"
/sbin/lsmod
echo
echo "Devices --------------------------------------------------------------------------"
ls -al /dev/nv*
ls -al /dev/
echo
echo "CPU status -----------------------------------------------------------------------"
cat /proc/cpuinfo
echo
echo "Memory status --------------------------------------------------------------------"
free -m
cat /proc/meminfo
echo
echo "Input Data -----------------------------------------------------------------------"
if [ -f /mnt/work/input/ports.json ]; then
  cp -av /mnt/work/input/ports.json /mnt/work/output/result/ports.json
fi
ls -alR /mnt/work/
exit 0
