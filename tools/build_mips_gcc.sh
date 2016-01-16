#!/bin/bash

WDIR=/tmp
TARGET=mips-elf
PREFIX=/opt/ddca/mips

tarball="gcc-4.8.2.tar.gz"
src_url="http://ftp.gnu.org/gnu/gcc/gcc-4.8.2/$tarball"
folder="build-gcc-bootstrap"
configure_flags="--target=$TARGET --prefix=$PREFIX \
  --enable-languages=c --without-headers \
  --with-gnu-ld --with-gnu-as \
  --disable-shared --disable-threads \
  --disable-libmudflap --disable-libgomp \
  --disable-libssp --disable-libquadmath \
  --disable-libatomic"

if [[ $EUID -ne 0  ]]; then
  echo >&2 "This script need to be run as root because it installs into ${PREFIX}."
  exit 1
fi

PATH="${PATH}":${PREFIX}/bin

cd $WDIR
mkdir -p ${TARGET}-toolchain  && cd ${TARGET}-toolchain

pwd
if [ ! -f $tarball ]; then
  wget $src_url
fi
if ! tar -xf $tarball; then
  echo >&2 "Could not unpack binutils tarball."
  exit 1
fi
mkdir -p ${folder} && cd ${folder}

../${tarball%.tar.gz}/configure $configure_flags

if ! make $MAKE_FLAGS ; then
  echo >&2 "Compilation failed."
  exit 1
fi

if ! make install; then
  echo >&2 "Installation failed."
  exit 1
fi

echo "Successfully compiled and installed binutils to $PREFIX."
