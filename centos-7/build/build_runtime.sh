#!/bin/bash
export BUILD_HOME=/build
export INSTALL_HOME=/opt/caffe
export PATH=$INSTALL_HOME/bin:$PATH

export CUDA_HOME=/usr/local/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

export LD_LIBRARY_PATH=${INSTALL_HOME}/lib:${INSTALL_HOME}/lib64:${LD_LIBRARY_PATH}
export LIBRARY_PATH=${INSTALL_HOME}/lib:${INSTALL_HOME}/lib64
export C_INCLUDE_PATH=${INSTALL_HOME}/include
export CPLUS_INCLUDE_PATH=$C_INCLUDE_PATH
export PKG_CONFIG_PATH=${INSTALL_HOME}/lib/pkgconfig
export PYTHONPATH=${INSTALL_HOME}/lib/python2.7/site-packages:${INSTALL_HOME}/lib64/python2.7/site-packages:${INSTALL_HOME}/python

export BOOST_ROOT=$INSTALL_HOME
export BOOST_DIR=$INSTALL_HOME
export HDF5_ROOT=$INSTALL_HOME
export OpenCV_DIR=$INSTALL_HOME

export BUILD_THREADS=8

BUILD_OPENBLAS=true

BUILD_PYTHON=true
INSTALL_CYTHON=true
BUILD_NUMPY=true
BUILD_SCIPY=true
BUILD_BOOST=true
INSTALL_PYTHON_MODULES=true

BUILD_GFLAGS=true
BUILD_GLOG=true
BUILD_PROTOBUF=true
BUILD_SNAPPY=true
BUILD_LEVELDB=true
BUILD_LMDB=true
BUILD_HDF5=true
BUILD_PROJ4=true
BUILD_GEOS=true
BUILD_GDAL=true

OPENCV_CUDA_ARCH="2.0 3.0 3.5"
# Choose OpenCV 2 or 3. Some ODP dependencies (pyvision) are incompatible with 3
BUILD_OPENCV_3=true
BUILD_OPENCV_2=false

export USE_CUDNN=1
BUILD_CAFFE_OPENBLAS=true

# Additional modules needed for ODP
BUILD_SPATIALINDEX=false
INSTALL_ODP_PYTHON_MODULES=false
INSTALL_PYVISION=false

# Package everything up
BUILD_PACKAGE=false

# Set up install directory library dirs - link lib to lib64
if ! [ -d ${INSTALL_HOME}/lib64 ]; then
  mkdir -p ${INSTALL_HOME}/lib64
  cd ${INSTALL_HOME}
  ln -s lib64 lib
fi

if ${BUILD_OPENBLAS}; then
  cd $BUILD_HOME
  if ! [ -f OpenBLAS-0.2.18.tar.gz ]; then
    wget -O OpenBLAS-0.2.18.tar.gz  https://github.com/xianyi/OpenBLAS/archive/v0.2.18.tar.gz
  fi
  if ! [ -d OpenBLAS-0.2.18 ]; then
    tar xvfz OpenBLAS-0.2.18.tar.gz
  fi
  cd OpenBLAS-0.2.18
  make clean
  make -j ${BUILD_THREADS} PREFIX=${INSTALL_HOME}
  make PREFIX=${INSTALL_HOME} install
fi

if ${BUILD_PYTHON}; then
  cd $BUILD_HOME
  if ! [ -f Python-2.7.11.tgz ]; then
    wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz
  fi
  if ! [ -d Python-2.7.11 ]; then
    tar xvfz Python-2.7.11.tgz
  fi
  cd Python-2.7.11
  make clean
  CFLAGS=-O2 CXXFLAGS=-O2 ./configure \
   --prefix=${INSTALL_HOME} \
   --enable-shared
  make -j ${BUILD_THREADS} && make install
fi

if ${INSTALL_CYTHON}; then
  cd $BUILD_HOME
  if ! [ -f get-pip.py ]; then
    wget https://bootstrap.pypa.io/get-pip.py
  fi
  if ! [ -f $INSTALL_HOME/bin/pip ]; then
     python get-pip.py
  fi
  pip install Cython==0.24
fi

if ${BUILD_NUMPY}; then
  cd $BUILD_HOME
  if ! [ -f numpy-1.11.0.tar.gz ]; then
    wget -O numpy-1.11.0.tar.gz  https://github.com/numpy/numpy/archive/v1.11.0.tar.gz
  fi
  if ! [ -d numpy-1.11.0 ]; then
    tar xvfz numpy-1.11.0.tar.gz
  fi
  cd numpy-1.11.0
  python setup.py build
  python setup.py install --prefix=${INSTALL_HOME}
fi

if ${BUILD_SCIPY}; then
  cd $BUILD_HOME
  if ! [ -f scipy-0.17.0.tar.gz ]; then
    wget https://github.com/scipy/scipy/releases/download/v0.17.0/scipy-0.17.0.tar.gz
  fi
  if ! [ -d scipy-0.17.0 ]; then
    tar xvfz scipy-0.17.0.tar.gz
  fi
  cd scipy-0.17.0
  python setup.py build
  python setup.py install --prefix=${INSTALL_HOME}
fi

if ${BUILD_BOOST}; then
  cd $BUILD_HOME
  if ! [ -f boost_1_59_0.tar.gz ]; then
    wget http://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
  fi
  if ! [ -d boost_1_59_0 ]; then
    tar xvfz boost_1_59_0.tar.gz
  fi
  cd boost_1_59_0
  ./bootstrap.sh --prefix=${INSTALL_HOME} \
                 --with-python=${INSTALL_HOME}/bin/python
  ./b2 install -j ${BUILD_THREADS} --prefix=${INSTALL_HOME} \
                 --with-python \
                 --with-thread \
                 --with-filesystem \
                 --with-system
fi

if ${INSTALL_PYTHON_MODULES}; then
  cd $BUILD_HOME
  if ! [ -f get-pip.py ]; then
    wget https://bootstrap.pypa.io/get-pip.py
  fi
  if ! [ -f $INSTALL_HOME/bin/pip ]; then
     python get-pip.py
  fi
  pip install pillow==2.9.0
  pip install scikit-image==0.12.3
  pip install protobuf
  pip install imutils yapps profilehooks
fi

if ${BUILD_GFLAGS}; then
  cd $BUILD_HOME
  if ! [ -f gflags-2.1.2.tar.gz ]; then
    wget -O gflags-2.1.2.tar.gz https://github.com/gflags/gflags/archive/v2.1.2.tar.gz
  fi
  if ! [ -d gflags-2.1.2 ]; then
    tar xvfz gflags-2.1.2.tar.gz
  fi
  cd gflags-2.1.2/
  if [ -d build ]; then
    rm -rf build
  fi
  mkdir build
  cd build
  cmake -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_INSTALL_PREFIX=${INSTALL_HOME} ..
  make && make install
fi

if ${BUILD_GLOG}; then
  cd $BUILD_HOME
  if ! [ -f glog-0.3.4.tar.gz ]; then
    wget -O glog-0.3.4.tar.gz https://github.com/google/glog/archive/v0.3.4.tar.gz
  fi
  if ! [ -d glog-0.3.4 ]; then
    tar xvfz glog-0.3.4.tar.gz
  fi
  cd glog-0.3.4
  make clean
  CPPFLAGS="-O2 -fPIC -I${INSTALL_HOME}/include" \
  CFLAGS=${CPPFLAGS} \
  LDFLAGS=-L${INSTALL_HOME}/lib \
  ./configure --prefix=${INSTALL_HOME}/
  make && make install
fi

if ${BUILD_PROTOBUF}; then
  cd $BUILD_HOME
  if ! [ -f protobuf-2.6.1.tar.gz ]; then
    wget https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz
  fi
  if ! [ -d protobuf-2.6.1 ]; then
    tar xvfz protobuf-2.6.1.tar.gz
  fi
  cd protobuf-2.6.1
  make clean
  CPPFLAGS="-O2 -fPIC -I${INSTALL_HOME}/include" \
  CFLAGS=${CPPFLAGS} \
  LDFLAGS=-L${INSTALL_HOME}/lib \
  ./configure --prefix=${INSTALL_HOME}/
  make && make install
fi

if ${BUILD_SNAPPY}; then
  cd $BUILD_HOME
  if ! [ -f snappy-1.1.3.tar.gz ]; then
    wget https://github.com/google/snappy/releases/download/1.1.3/snappy-1.1.3.tar.gz
  fi
  if ! [ -d snappy-1.1.3 ]; then
    tar xvfz snappy-1.1.3.tar.gz
  fi
  cd snappy-1.1.3
  if ! [ -f configure ]; then
    autoreconf --install
  fi
  make clean
  CPPFLAGS="-O2 -fPIC -I${INSTALL_HOME}/include" \
  CFLAGS=${CPPFLAGS} \
  LDFLAGS=-L${INSTALL_HOME}/lib \
  ./configure --prefix=${INSTALL_HOME}/
  make && make install
fi

if ${BUILD_LEVELDB}; then
  cd $BUILD_HOME
  if ! [ -f leveldb-1.18.tar.gz ]; then
    wget -O leveldb-1.18.tar.gz https://github.com/google/leveldb/archive/v1.18.tar.gz
  fi
  if [ -d leveldb-1.18 ]; then
    rm -rf leveldb-1.18
  fi
  tar xvfz leveldb-1.18.tar.gz
  cd leveldb-1.18
  cp Makefile Makefile.orig
  sed 's/OPT ?= -O2 -DNDEBUG/OPT ?= -O2 -fPIC -DNDEBUG/' Makefile.orig > Makefile
  make
  cp -a libleveldb* ${INSTALL_HOME}/lib/
  cp -a include/* ${INSTALL_HOME}/include/
fi

if ${BUILD_LMDB}; then
  cd $BUILD_HOME
  if ! [ -f LMDB_0.9.17.tar.gz ]; then
    wget https://github.com/LMDB/lmdb/archive/LMDB_0.9.17.tar.gz
  fi
  if [ -d lmdb-LMDB_0.9.17 ]; then
    rm -rf lmdb-LMDB_0.9.17
  fi
  tar xvfz LMDB_0.9.17.tar.gz
  cd lmdb-LMDB_0.9.17/libraries/liblmdb
  sed -i 's/OPT = -O2 -g/OPT = -O2 -fPIC/' Makefile
  make
  cp -av liblmdb* ${INSTALL_HOME}/lib/
  cp -av *.h ${INSTALL_HOME}/include/
fi

if ${BUILD_HDF5}; then
  cd $BUILD_HOME
  if ! [ -f hdf5-1.8.16.tar.gz ]; then
    wget http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.16.tar.gz
  fi
  if ! [ -d hdf5-1.8.16 ]; then
    tar xvfz hdf5-1.8.16.tar.gz
  fi
  cd hdf5-1.8.16
  make clean
  CPPFLAGS="-O2 -fPIC -I${INSTALL_HOME}/include" \
  CFLAGS=${CPPFLAGS} \
  LDFLAGS=-L${INSTALL_HOME}/lib \
  ./configure --prefix=${INSTALL_HOME} --enable-cxx
  make && make install
fi

if ${BUILD_PROJ4}; then
  cd $BUILD_HOME
  if ! [ -f proj-4.8.0.tar.gz ]; then
    wget -O proj-4.8.0.tar.gz https://github.com/OSGeo/proj.4/archive/4.8.0.tar.gz
  fi
  if ! [ -d proj.4-4.8.0 ]; then
    tar xvfz proj-4.8.0.tar.gz
  fi
  cd proj.4-4.8.0
  make clean
  CFLAGS=-O2 CXXFLAGS=-O2 ./configure --prefix=${INSTALL_HOME}
  make && make install
fi

if ${BUILD_GEOS}; then
  cd $BUILD_HOME
  if ! [ -f geos-3.4.2.tar.bz2 ]; then
    wget http://download.osgeo.org/geos/geos-3.4.2.tar.bz2
  fi
  if ! [ -d geos-3.4.2 ]; then
    tar xvfj geos-3.4.2.tar.bz2
  fi
  cd geos-3.4.2
  make clean
  CFLAGS=-O2 CXXFLAGS=-O2 ./configure --prefix=${INSTALL_HOME}
  make && make install
fi

if ${BUILD_GDAL}; then
  cd $BUILD_HOME
  #if ! [ -d fgdb ]; then
  #  tar xvfz fgdb.tar.gz
  #fi
  if ! [ -f gdal-1.11.3.tar.gz ]; then
    wget http://download.osgeo.org/gdal/1.11.3/gdal-1.11.3.tar.gz
  fi
  if ! [ -d gdal-1.11.3 ]; then
    tar xvfz gdal-1.11.3.tar.gz
  fi
  cd gdal-1.11.3
  make clean
  CFLAGS=-O2 CXXFLAGS=-O2 LDFLAGS="-L/usr/lib64" ./configure \
   --prefix=${INSTALL_HOME} \
   --with-threads \
   --with-libz=internal \
   --with-png=internal \
   --with-jpeg=internal \
   --with-gif=internal \
   --with-python=${INSTALL_HOME}/bin/python
   # --with-fgdb=${BUILD_HOME}/fgdb/
  make -j ${BUILD_THREADS} && make install
  # Copy ESRI fgdb libs
  # cp -av ${BUILD_HOME}/fgdb/lib/*.so ${INSTALL_HOME}/lib/
fi

if ${BUILD_OPENCV_3}; then
  cd $BUILD_HOME
  if ! [ -f opencv-3.1.0.tar.gz ]; then
    wget -O opencv-3.1.0.tar.gz https://github.com/Itseez/opencv/archive/3.1.0.tar.gz
  fi
  if ! [ -d opencv-3.1.0 ]; then
    tar xvfz opencv-3.1.0.tar.gz
  fi
  cd opencv-3.1.0
  if [ -d build ]; then
    rm -rf build
  fi
  mkdir build
  cd build
  cmake -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_HOME} \
        -DCUDA_ARCH_BIN=${OPENCV_CUDA_ARCH} \
        -DPYTHON2_EXECUTABLE=${INSTALL_HOME}/bin/python2.7 \
        -DPYTHON2_LIBRARY=${INSTALL_HOME}/lib/libpython2.7.so \
        -DPYTHON2_INCLUDE_DIR=${INSTALL_HOME}/include/python2.7 \
        -DWITH_GTK=OFF -DWITH_GTK_2_X=ON \
        ..
  make -j ${BUILD_THREADS}  && make install
elif ${BUILD_OPENCV_2}; then
  cd $BUILD_HOME
  if ! [ -f opencv-2.4.12.3.tar.gz ]; then
    wget -O opencv-2.4.12.3.tar.gz https://github.com/Itseez/opencv/archive/2.4.12.3.tar.gz

  fi
  if ! [ -d opencv-2.4.12.3 ]; then
    tar xvfz opencv-2.4.12.3.tar.gz
  fi
  cd opencv-2.4.12.3
  if [ -d build ]; then
    rm -rf build
  fi
  mkdir build
  cd build
  cmake -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_HOME} \
        -DCUDA_ARCH_BIN=${OPENCV_CUDA_ARCH} \
        -DPYTHON2_EXECUTABLE=${INSTALL_HOME}/bin/python2.7 \
        -DPYTHON2_LIBRARY=${INSTALL_HOME}/lib/libpython2.7.so \
        -DPYTHON2_INCLUDE_DIR=${INSTALL_HOME}/include/python2.7 \
        -DWITH_GTK=OFF -DWITH_GTK_2_X=ON \
        ..
  make -j ${BUILD_THREADS}  && make install
fi

if ${BUILD_CAFFE_OPENBLAS}; then
  cd $BUILD_HOME
  if ! [ -f NVcaffe-0.14.2.tar.gz ]; then
    wget -O NVcaffe-0.14.2.tar.gz https://github.com/NVIDIA/caffe/archive/v0.14.2.tar.gz
  fi
  if ! [ -d caffe-0.14.2 ]; then
    tar xvfz NVcaffe-0.14.2.tar.gz
    #git clone https://github.com/NVIDIA/caffe.git
    #git clone https://github.com/BVLC/caffe.git
  fi
  cd caffe-0.14.2
  #git fetch origin
  #git rebase origin/master
  if [ -d build ]; then
    rm -rf build
  fi
  mkdir build
  cd build
  cmake -DBLAS=open \
        -DUSE_CUDNN=${USE_CUDNN} \
        -DHDF5_DIR=${INSTALL_HOME} \
        -DGFLAGS_INCLUDE_DIR=${INSTALL_HOME}/include \
        -DGFLAGS_LIBRARY=${INSTALL_HOME}/lib/libgflags.a \
        -DGLOG_INCLUDE_DIR=${INSTALL_HOME}/include \
        -DGLOG_LIBRARY=${INSTALL_HOME}/lib/libglog.a \
        -DLMDB_INCLUDE_DIR=${INSTALL_HOME}/include \
        -DLMDB_LIBRARIES=${INSTALL_HOME}/lib/liblmdb.a \
        -DLevelDB_INCLUDE=${INSTALL_HOME}/include \
        -DLevelDB_LIBRARY=${INSTALL_HOME}/lib/libleveldb.a \
        -DCMAKE_INSTALL_PREFIX=${INSTALL_HOME} \
        -DPYTHON_EXECUTABLE=${INSTALL_HOME}/bin/python \
        -DPYTHON_INCLUDE_DIR=${INSTALL_HOME}/include/python2.7 \
        -DPYTHON_LIBRARY=${INSTALL_HOME}/lib/libpython2.7.so \
        ..
  make all -j ${BUILD_THREADS}
  #make runtest -j ${BUILD_THREADS}
  make install
fi

# ---------------------- ODP Dependencies ---------------------

if ${BUILD_SPATIALINDEX}; then
  cd $BUILD_HOME
  if ! [ -f spatialindex-src-1.8.5.tar.gz ]; then
    wget http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.5.tar.gz
  fi
  if ! [ -d spatialindex-src-1.8.5 ]; then
    tar xvfz spatialindex-src-1.8.5.tar.gz
  fi
  cd spatialindex-src-1.8.5
  make clean
  CFLAGS=-O2 CXXFLAGS=-O2 ./configure --prefix=${INSTALL_HOME}
  make && make install
fi

if ${INSTALL_ODP_PYTHON_MODULES}; then
  cd $BUILD_HOME
  if ! [ -f get-pip.py ]; then
    wget -P https://bootstrap.pypa.io/get-pip.py
  fi
  if ! [ -f $INSTALL_HOME/bin/pip ]; then
     python get-pip.py
  fi
  pip install scikit-learn==0.17.1
  pip install pycuda mako scikit-cuda
  pip install rtree # Depends on libspatialindex above
  pip install shapely fiona
  pip install pillow==2.9.0
  pip install psutil smart_open
  # For database connectivity, requires postgres client installed
  # pip install psycopg2
  # For interactive sessions and development, uncomment the following
  # pip install ipython jupyter
fi

if ${INSTALL_PYVISION}; then
  cd $BUILD_HOME
  if ! [ -d pyvision-svohara ]; then
    # tar xvfz pyvision-svohara.tar.gz
    git clone https://github.com/svohara/pyvision.git pyvision-svohara
  fi
  cd pyvision-svohara/src
  if [ -d ${INSTALL_HOME}/lib/python2.7/site-packages/pyvision ]; then
    rm -rf ${INSTALL_HOME}/lib/python2.7/site-packages/pyvision
  fi
  cp -av pyvision ${INSTALL_HOME}/lib/python2.7/site-packages/
fi

if ${BUILD_PACKAGE}; then
  cd $INSTALL_HOME
  if [ -f $BUILD_HOME/runtime.tar.bz2 ]; then
    rm -f $BUILD_HOME/runtime.tar.bz2
  fi
  tar cvfj $BUILD_HOME/runtime.tar.bz2 * .*
fi

echo "/opt/caffe/lib" >> /etc/ld.so.conf.d/caffe.conf
echo "/opt/caffe/lib64" >> /etc/ld.so.conf.d/caffe.conf
ldconfig
echo 'export PATH=/opt/caffe/bin:$PATH' > /etc/profile.d/caffe.sh
echo "export LIBRARY_PATH=${LIBRARY_PATH}" >> /etc/profile.d/caffe.sh
echo "export PYTHONPATH=${PYTHONPATH}" >> /etc/profile.d/caffe.sh
chmod +x /etc/profile.d/caffe.sh

# cleanup
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
