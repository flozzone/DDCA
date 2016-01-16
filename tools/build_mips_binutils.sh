#!/bin/bash


binutils_tar="binutils-2.25.tar.gz"
binutils_src="http://ftp.gnu.org/gnu/binutils/$binutils_tar"

WDIR=/tmp
TARGET=mips-elf
PREFIX=/opt/ddca/mips

if [[ $EUID -ne 0  ]]; then
  echo >&2 "This script need to be run as root because it installs into ${PREFIX}."
  exit 1
fi

PATH="${PATH}":${PREFIX}/bin

cd $WDIR
mkdir -p ${TARGET}-toolchain  && cd ${TARGET}-toolchain

pwd
if [ ! -f $binutils_tar ]; then
  wget $binutils_src
fi
if ! tar -xf $binutils_tar; then
  echo >&2 "Could not unpack binutils tarball."
  exit 1
fi
mkdir -p build-binutils && cd build-binutils
../${binutils_tar%.tar.gz}/configure --target=$TARGET --prefix=$PREFIX
if ! make $MAKE_FLAGS ; then
  echo >&2 "Compilation failed."
  exit 1
fi

if ! make install; then
  echo >&2 "Installation failed."
  exit 1
fi

echo "Successfully compiled and installed binutils to $PREFIX."
