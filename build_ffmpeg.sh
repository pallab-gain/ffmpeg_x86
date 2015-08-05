#!/bin/bash


src_root=`pwd`

ANDROID_NDK_ROOT=/home/pallab/Documents/IDE/Sdk/ndk-bundle
NDK=$ANDROID_NDK_ROOT  #your ndk root path
PLATFORM=$NDK/platforms/android-19/arch-x86
PREBUILT=$NDK/toolchains/x86-4.8/prebuilt/linux-x86_64
OPEN_SSL=${src_root}/openssl-android/libs/x86
RTMP_DIR=${src_root}/librtmp/libs/x86
RTMP_BASE=${src_root}/librtmp


function clone_ffmpeg() {
  # download ffmpeg
  ffmpeg_archive=${src_root}/ffmpeg-snapshot.tar.bz2
  if [ ! -f "${ffmpeg_archive}" ]; then
    wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
  fi

  # extract ffmpeg
  if [ ! -d "${src_root}/ffmpeg" ]; then
    cd ${src_root}
    tar xvfj ${ffmpeg_archive}
  fi
}
function apply_patch(){
  echo "Applying patch for x86 android build ..."
  patch -u ${src_root}/ffmpeg/configure ${src_root}/patches/ffmpeg-x86.patch
}
function apply_patch_librtmp_pkg_fix(){
  echo "Applying patch for pkg path ..."
  patch -u ${src_root}/ffmpeg/configure ${src_root}/patches/ffmpeg_x86_librtmppkgfix.patch
}

function build_ffmpeg(){
  apply_patch_librtmp_pkg_fix

  addi_cflags="-march=x86"
  cd ${src_root}/ffmpeg
  ./configure \
    --target-os=linux --enable-shared --enable-decoder=h264 \
    --prefix=$PREFIX \
    --enable-cross-compile \
    --extra-libs="-lgcc" \
    --arch=x86 \
    --cc=$PREBUILT/bin/i686-linux-android-gcc \
    --cross-prefix=$PREBUILT/bin/i686-linux-android- \
    --nm=$PREBUILT/bin/i686-linux-android-nm \
    --sysroot=$PLATFORM \
    --enable-librtmp \
    --extra-cflags=" -O3 -fpic -DANDROID -DHAVE_SYS_UIO_H=1 -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS -I${RTMP_BASE}" \
    --disable-static \
    --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -L${OPEN_SSL} -L${RTMP_DIR} -lrtmp" \
--disable-ffplay --disable-ffserver --disable-symver --disable-ffprobe \
--enable-asm \
--enable-yasm $ADDITIONAL_CONFIGURE_FLAG 

make clean
make  -j4 install
}



#x86
CPU=x86
OPTIMIZE_CFLAGS="-march=atom -ffast-math -msse3 -mfpmath=sse"
PREFIX=./android/$CPU
ADDITIONAL_CONFIGURE_FLAG=

clone_ffmpeg
apply_patch
build_ffmpeg