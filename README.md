# gbdx-gpu-docker
Building GPU docker containers for GBDX with support for Caffe and OpenCV from scratch.

### GPU domain
The first rendition of GPU workflows on GBDX required container images to have gpu drivers matching the host drivers installed. You can find instructions on how to build such containers in the gpu_domain folder.

### NVIDIAGPU domain
More recent releases of GBDX feature a runtime based on Nvidia's nvidia-docker plugin. This allows you to build docker containers that are ( within limits ) independent of the host drivers - the host driver is mapped into the container at runtime. You can find simple examples of how to build such containers in the nvidiagpu_domain folder.
 
