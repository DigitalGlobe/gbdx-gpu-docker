#!/bin/bash
RESULT=0
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
nvidia-smi
nvidia-smi -q
echo "Theano Test -------------------------------------------------"
/usr/bin/python theano-test.py
exit $RESULT
