#!/bin/bash


src_root=`pwd`
NDK=/home/pallab/Documents/IDE/Sdk/ndk-bundle

function build_openssl () {
  echo "Cloning openssl-android ..."
  test -d ${src_root}/openssl-android || \
  git clone https://github.com/pallab-gain/openssl-android.git ${src_root}/openssl-android 
}
function apply_patch(){
  echo "Applying patch for x86 android build ..."
  patch -u ${src_root}/openssl-android/jni/Application.mk ${src_root}/patches/ssl_x86.patch 
}
function build_openssl(){
  cd ${src_root}/openssl-android
  ${NDK}/ndk-build
}

build_openssl
apply_patch
build_openssl