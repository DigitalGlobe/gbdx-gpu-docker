FROM nvidia/cuda:7.5-cudnn5-devel
MAINTAINER DigitalGlobe Inc. <ctusk@digitalglobe.com>
RUN apt-get -y update && \
    apt-get -y install python python-pip python-six python-numpy python-scipy \
                       libopenblas-dev libyaml-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN pip install Theano Keras
COPY app.py theano-test.py cudatest.sh launcher.sh /opt/app/
COPY .theanorc /root/.theanorc
WORKDIR /opt/app
CMD ["/bin/bash","launcher.sh"]
