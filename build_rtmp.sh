#!/bin/bash


src_root=`pwd`
NDK=/home/pallab/Documents/IDE/Sdk/ndk-bundle

function clone_rtmp() {
  echo "Cloning librtmp ..."
  test -d ${src_root}/librtmp || \
  git clone https://github.com/pallab-gain/librtmp.git
}
function apply_patch(){
  echo "Applying patch for x86 android build ..."
  patch -u ${src_root}/librtmp/jni/Application.mk ${src_root}/patches/librtmp_x86.patch 
  patch -u ${src_root}/librtmp/Android.mk ${src_root}/patches/rtmpssl_path.patch 
}
function build_rtmp(){
  cd ${src_root}/librtmp
  ${NDK}/ndk-build
}

clone_rtmp
apply_patch
build_rtmp