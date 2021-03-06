FROM ubuntu:eoan
MAINTAINER David Carlier <devnexen@gmail.com>
LABEL "about"="AFLplusplus docker image"
RUN apt-get update && apt-get -y install \
    --no-install-suggests --no-install-recommends \
    automake \
    bison \
    build-essential \
    clang \
    clang-9 \
    flex \
    git \
    python3.7 \
    python3.7-dev \
    gcc-9 \
    gcc-9-plugin-dev \
    gcc-9-multilib \
    libc++-9-dev \
    libtool \
    libtool-bin \
    libglib2.0-dev \
    llvm-9-dev \
    python-setuptools \
    python2.7-dev \
    wget \
    ca-certificates \
    libpixman-1-dev \
    python3-dev \
    cmake \
    make \
    git \
    ca-certificates \
    tar \
    gzip \
    vim \
    curl \
    apt-utils \
    libelf-dev \
    libelf1 \
    libiberty-dev \
    libboost-all-dev \
    libtbb2 \
    llvm-runtime \
    libtbb-dev && rm -rf /var/lib/apt/lists/* && ln /bin/llvm-config-9 /bin/llvm-config 

ARG CC=gcc-9
ARG CXX=g++-9
ARG LLVM_CONFIG=llvm-config-9

RUN git clone https://github.com/wolfpro/AFLplusplus
RUN git clone https://github.com/dyninst/dyninst
RUN git clone https://github.com/vanhauser-thc/afl-dyninst
RUN git clone https://github.com/DynamoRIO/dynamorio

RUN export AFL_PATH=/AFLplusplus
RUN cd AFLplusplus && make clean && make distrib && \
    make install && cd .. 
   
RUN cd dyninst && ln -s ../AFLplusplus afl && ls  && mkdir build && cmake /dyninst -DCMAKE_INSTALL_PREFIX=/dyninst/build && make install && cd ..

RUN cd afl-dyninst \
    && ln -s ../AFLplusplus afl \
    && cp ../AFLplusplus/scripts/Makefile_afl-dyninst Makefile \    
    && make \
    && make install \
    && cd .. \
    && echo "/usr/local/lib" > /etc/ld.so.conf.d/dyninst.conf && ldconfig \
    && echo "export DYNINSTAPI_RT_LIB=/usr/local/lib/libdyninstAPI_RT.so" >> .bashrc

ENV DYNINSTAPI_RT_LIB /usr/local/lib/libdyninstAPI_RT.so

RUN cd dynamorio && cmake . && make && make install &&  cd ..

RUN git clone https://github.com/vanhauser-thc/afl-dynamorio
RUN cd afl-dynamorio && ln -s ../AFLplusplus afl && export DYNAMORIO_HOME=/dynamorio && make && make install

 