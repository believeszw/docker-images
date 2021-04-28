#!/bin/bash

libev_root_dir="/home/libevent"
libev_src_dir="${libev_root_dir}/src"
libev_release_dir="${libev_root_dir}/release"
echo "libev_root_dir:" ${libev_root_dir}

if [ ! -d ${libev_root_dir} ]; then
    mkdir -p ${libev_src_dir}
    mkdir -p ${libev_release_dir}
fi

if [ ! -d ${libev_release_dir}/lib/libevent.a ]; then
  # download libevent
  cd ${libev_src_dir}
  if [ ! -d libevent-2.1.12-stable ]; then
    curl -LO https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
    tar -xvf libevent-2.1.12-stable.tar.gz
  fi
  cd libevent-2.1.12-stable

  # build libevent
  ./configure --prefix=${libev_release_dir}
  make -j32 && make install
fi

PATH="${libev_release_dir}:$PATH"
echo $PATH
export C_INCLUDE_PATH="${libev_release_dir}/include:$C_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="${libev_release_dir}/include:$CPLUS_INCLUDE_PATH"
echo $C_INCLUDE_PATH
echo $CPLUS_INCLUDE_PATH
