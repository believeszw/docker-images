#!/bin/zsh

ff_root_dir="/home/ffmpeg"
ff_src_dir="${ff_root_dir}/src"
ff_build_dir="${ff_root_dir}/build"
ff_release_dir="${ff_root_dir}/bin"
echo "ff_root_dir:" ${ff_root_dir}

if [ ! -d ${ff_root_dir} ]; then
    mkdir -p ${ff_src_dir}
    mkdir -p ${ff_build_dir}
    mkdir -p ${ff_release_dir}
fi

apt-get install -y libbz2-dev liblzma-dev libnuma1 libnuma-dev zlib1g-dev libtool yasm

# yasm
if [[ -f ${ff_release_dir}/nasm ]]; then
    echo "nasm is ok"
else
    echo "build nasm"
    cd ${ff_src_dir} && \
    wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 && \
    tar xjvf nasm-2.14.02.tar.bz2 && \
    cd nasm-2.14.02 && \
    ./autogen.sh && \
    PATH="${ff_release_dir}:$PATH" ./configure --prefix="${ff_build_dir}" --bindir="${ff_release_dir}" && \
    make -j16 && \
    make install
fi

# libx264
if [[ -f ${ff_release_dir}/x264 ]]; then
    echo "x264 is ok"
else
    echo "build x264"
    cd ${ff_src_dir} && \
    git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git && \
    cd x264 && \
    PATH="${ff_release_dir}:$PATH" PKG_CONFIG_PATH="${ff_build_dir}/lib/pkgconfig" ./configure --prefix="${ff_build_dir}" --bindir="${ff_release_dir}" --enable-static --enable-pic && \
    PATH="${ff_release_dir}:$PATH" make -j16 && \
    make install
fi

# libx265
if [[ -f ${ff_build_dir}/bin/x265 ]]; then
    echo "x265 is ok"
else
    echo "build x265"
    apt-get install libnuma-dev && \
    cd ${ff_src_dir} && \
    git -C x265_git pull 2> /dev/null || git clone https://bitbucket.org/multicoreware/x265_git && \
    cd x265_git/build/linux && \
    PATH="${ff_release_dir}:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${ff_build_dir}" -DENABLE_SHARED=off ../../source && \
    PATH="${ff_release_dir}:$PATH" make -j16 && \
    make install
fi

# libvpx
if [[ -f ${ff_build_dir}/lib/libvpx.a ]]; then
    echo "vpx is ok"
else
    echo "build vpx"
    cd ${ff_src_dir} && \
    git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
    cd libvpx && \
    PATH="${ff_release_dir}:$PATH" ./configure --prefix="${ff_build_dir}" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
    PATH="${ff_release_dir}:$PATH" make -j16 && \
    make install
fi

# libfdk-aac
if [[ -f ${ff_build_dir}/lib/libfdk-aac.a ]]; then
    echo "libfdk_aac is ok"
else
    echo "build fdk-aac"
    cd ${ff_src_dir} && \
    git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
    cd fdk-aac && \
    autoreconf -fiv && \
    ./configure --prefix="${ff_build_dir}" --disable-shared && \
    make -j16 && \
    make install
fi


# libmp3lame
if [[ -f ${ff_release_dir}/lame ]]; then
    echo "mp3lame is ok"
else
    echo "build mp3lame"
    cd ${ff_src_dir} && \
    wget -O lame-3.100.tar.gz https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz && \
    tar xzvf lame-3.100.tar.gz && \
    cd lame-3.100 && \
    PATH="${ff_release_dir}:$PATH" ./configure --prefix="${ff_build_dir}" --bindir="${ff_release_dir}" --disable-shared --enable-nasm && \
    PATH="${ff_release_dir}:$PATH" make -j16 && \
    make install
fi



# libopus
if [[ -f ${ff_build_dir}/lib/libopus.a ]]; then
    echo "opus is ok"
else
    echo "build opus"
    cd ${ff_src_dir} && \
    git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
    cd opus && \
    ./autogen.sh && \
    ./configure --prefix="${ff_build_dir}" --disable-shared && \
    make -j16 && \
    make install
fi

# libaom
if [[ -f ${ff_build_dir}/lib/libaom.a ]]; then
    echo "aom is ok"
else
    echo "build aom"
    cd ${ff_src_dir} && \
    git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
    mkdir -p aom_build && \
    cd aom_build && \
    PATH="${ff_release_dir}:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${ff_build_dir}" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom && \
    PATH="${ff_release_dir}:$PATH" make -j16 && \
    make install
fi

# libsvtav1
if [[ -f ${ff_build_dir}/lib/libSvtAv1Enc.a ]]; then
    echo "svtav1 is ok"
else
    echo "build svtav1"
    cd ${ff_src_dir} && \
    git -C SVT-AV1 pull 2> /dev/null || git clone https://github.com/AOMediaCodec/SVT-AV1.git && \
    mkdir -p SVT-AV1/build && \
    cd SVT-AV1/build && \
    PATH="${ff_release_dir}:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${ff_build_dir}" -DCMAKE_BUILD_TYPE=Release -DBUILD_DEC=OFF -DBUILD_SHARED_LIBS=OFF .. && \
    PATH="${ff_release_dir}:$PATH" make -j16 && \
    make install
fi

# FFmpeg
if [[ -f ${ff_release_dir}/ffmpeg ]]; then
    echo "ffmpeg is ok"
else
    echo "build ffmpeg"
    cd ${ff_src_dir} && \
    wget -O ffmpeg-4.1.tar.bz2  https://ffmpeg.org/releases/ffmpeg-4.1.tar.bz2  && \
    tar xjvf ffmpeg-4.1.tar.bz2  && \
    cd ffmpeg-4.1 && \
    PATH="${ff_release_dir}:$PATH" PKG_CONFIG_PATH="${ff_build_dir}/lib/pkgconfig" ./configure \
      --enable-gpl --enable-nonfree \
      --prefix="${ff_build_dir}" \
      --pkg-config-flags="--static" \
      --extra-cflags="-I/${ff_build_dir}/include" \
      --extra-ldflags="-L/${ff_build_dir}/lib" \
      --extra-libs="-lpthread -lm -ldl" \
      --bindir="${ff_release_dir}" \
      --enable-static \
      --disable-shared \
      --disable-debug \
      --disable-ffplay \
      --disable-ffprobe \
      --disable-doc \
      --enable-postproc  \
      --enable-bzlib \
      --enable-zlib \
      --enable-parsers \
      --enable-libx264 --enable-libmp3lame --enable-libfdk-aac \
      --enable-encoder=libfdk_aac --enable-decoder=libfdk_aac \
      --enable-muxer=adts \
      --enable-pthreads --extra-libs=-lpthread \
      --enable-encoders --enable-decoders --enable-avfilter --enable-muxers --enable-demuxers && \
    PATH="${ff_release_dir}:$PATH" && make -j16 && \
    make install && \
    hash -r
fi
PATH="${ff_release_dir}:$PATH"
echo $PATH
