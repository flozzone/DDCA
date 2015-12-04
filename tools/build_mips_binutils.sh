#!/bin/bash


binutils_tar="binutils-2.25.tar.gz"
binutils_src="http://ftp.gnu.org/gnu/binutils/$binutils_tar"

WDIR=/tmp
TARGET=mips-elf
PREFIX=/usr/mips

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
tar -xvf $binutils_tar
mkdir -p build-binutils && cd build-binutils
../${binutils_tar%.tar.gz}/configure --target=$TARGET --prefix=$PREFIX
make
make install
