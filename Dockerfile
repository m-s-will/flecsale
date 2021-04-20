# This Dockerfile creates a docker image for running flecsale in containers
# at Elwetritsch TU KL.  
# The general expectation is that this container and ones layered on top of it
# will be run using Singularity with a cleaned environment and a contained
# file systems (e.g. singularity run -eC container.sif). The Singularity command
# is responsible for binding in the appropriate environment variables,
# directories, and files to make this work.

FROM beelanl/openmpi_2.0.2

SHELL ["/bin/bash", "-l", "-c"]
ARG DEBIAN_FRONTEND=noninteractive
# RUN apt-get update && apt-get upgrade -y && apt-get install -y cmake \
#     libgl1-mesa-dev libxt-dev qt5-default libqt5x11extras5-dev \
#     libqt5help5 qttools5-dev qtxmlpatterns5-dev-tools libqt5svg5-dev \
#     git build-essential gfortran libx11-dev flex curl clang nano \
#     python3-dev  python3-numpy libopenmpi-dev libssl-dev wget environment-modules\
#     binutils-gold autotools-dev automake unzip dos2unix libtbb-dev ninja-build libcereal-dev
RUN apt-get update && apt-get upgrade -y && apt-get -y install \
    git \
    wget \
    curl \
    cmake \
    build-essential \
    python2.7 python-dev \
    freeglut3-dev \
    qt4-dev-tools \
    libcereal-dev \
    unzip \
    dos2unix \
    libssl-dev python3-dev python3-numpy python3-pip

# We do most of our work in /home/docker for the same reason. This just
# sets up the base environment in which we can build more sophisticated
# containers
RUN mkdir /home/docker
RUN chmod 777 /home/docker


# install newer cmake version
RUN cd $HOME; wget https://github.com/Kitware/CMake/releases/download/v3.18.1/cmake-3.18.1.tar.gz; mkdir build; cd build; tar xvfz ../cmake-3.18.1.tar.gz;
RUN cd $HOME/build/cmake-3.18.1/; ./bootstrap; make; make install;

# needed by mesa
RUN pip install mako

# install llvm
RUN apt install -y libomxil-bellagio-dev llvm
#install mesa
WORKDIR /usr/local
RUN wget mesa.freedesktop.org/archive/older-versions/13.x/13.0.6/mesa-13.0.6.tar.gz && tar xvzf mesa-13.0.6.tar.gz && rm mesa-13.0.6.tar.gz

WORKDIR /usr/local/mesa-13.0.6

RUN autoreconf -fi
RUN ./configure \
    --enable-osmesa\
    --disable-glx \
    --disable-driglx-direct\ 
    --disable-dri\ 
    --disable-egl \
    --with-gallium-drivers=swrast,swr

RUN make -j 8; make install;


# build glu
ENV C_INCLUDE_PATH '/usr/local/mesa-13.0.6/include'
ENV CPLUS_INCLUDE_PATH '/usr/local/mesa-13.0.6/include'
WORKDIR /usr/local
RUN git clone http://anongit.freedesktop.org/git/mesa/glu.git

WORKDIR /usr/local/glu
RUN ./autogen.sh --enable-osmesa
RUN ./configure --enable-osmesa
RUN make -j 8
RUN make install

#install paraview
WORKDIR /home/docker/
RUN mkdir paraview; wget https://www.paraview.org/files/v5.6/ParaView-v5.6.0.tar.gz; tar -zxvf ParaView-v5.6.0.tar.gz -C paraview --strip-components 1;
# Build paraview

# RUN cd /home/docker/; mkdir paraview_build; cd paraview_build; \ 
#     cmake \
#     -DBUILD_TESTING=OFF \
#     -DPARAVIEW_BUILD_EDITION=CATALYST_RENDERING \
#     -DPARAVIEW_USE_CATALYST=ON  \
#     -DPARAVIEW_USE_PYTHON=ON \
#     -DPARAVIEW_USE_QT=OFF \
#     -DVTK_USE_X=OFF \
#     -DOPENGL_INCLUDE_DIR=/usr/local/mesa-13.0.6/include \
#     -DOPENGL_gl_LIBRARY=/usr/local/mesa-13.0.6/lib/libOSMesa.so \
#     -DVTK_OPENGL_HAS_OSMESA=ON \
#     -DOSMESA_INCLUDE_DIR=/usr/local/mesa-13.0.6/include \
#     -DOSMESA_LIBRARY=/usr/local/mesa-13.0.6/lib/libOSMesa.so \
#     -DPARAVIEW_USE_MPI=ON \
#     ../paraview; make -j 8; make install;

RUN mkdir paraview_build; cd paraview_build; \
    cmake \
    -DBUILD_TESTING=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DPARAVIEW_ENABLE_CATALYST=ON  \
    -DPARAVIEW_ENABLE_PYTHON=ON \
    -DPARAVIEW_BUILD_QT_GUI=OFF \
    -DVTK_USE_X=OFF \
    -DOPENGL_INCLUDE_DIR=/usr/local/mesa-13.0.6/include \
    -DOPENGL_gl_LIBRARY=/usr/local/mesa-13.0.6/lib/libOSMesa.so \
    -DVTK_OPENGL_HAS_OSMESA=ON \
    -DOSMESA_INCLUDE_DIR=/usr/local/mesa-13.0.6/include \
    -DOSMESA_LIBRARY=/usr/local/mesa-13.0.6/lib/libOSMesa.so \
    -DPARAVIEW_USE_MPI=ON \
    ../paraview; make -j 8; make install;
ENV ParaView_DIR=""/home/docker/paraview_build""



# add updated flecsale folder
#RUN rm -r /opt/flecsale;
COPY flecsale /home/docker/flecsale/

# build flecsale
RUN mkdir flecsale_build; cd flecsale_build; \
    CC=mpicc CXX=mpic++ cmake \
    -DParaView_DIR=/home/docker/paraview_build/ \
    -DVTK_DIR=/home/docker/paraview_build/VTK/ \
    -DUSE_CATALYST=ON \
    ../flecsale/; make -j;





# Copy environment scripts
COPY entrypoint.sh /home/docker/entrypoint.sh


RUN dos2unix /home/docker/entrypoint.sh
RUN chmod +x /home/docker/entrypoint.sh

# expose paraview server from outside the container
EXPOSE 11111

#CMD /opt/paraview_build/bin/pvserver
#CMD ["/bin/bash"]
ENTRYPOINT ["/home/docker/paraview_build/bin/pvserver"]
