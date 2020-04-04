#! /bin/sh
#-----------------------------------------------------------------------------#
# Author: Mark Bellaire
# Year  : 2020
#-----------------------------------------------------------------------------#
#
# This script prepares the Mercury source tree for building with an Android
# cross-compiler.  Please see the README for details.
#
#-----------------------------------------------------------------------------#

NDK=${NDK:-/opt/android-ndk-r20b}
HOST_TAG=${HOST_TAG:-linux-x86_64}
ANDROID_SDK=${ANDROID_SDK:-21}
MERCURYHOME=${MERCURYHOME:-/usr/local/mercury-DEV}
PREFIX=${PREFIX:-/opt/android/cross/mercury}
ROTD=${ROTD:-2020-03-29}
ABIS=${ABIS:-"armv7a-linux-androideabi aarch64-linux-android i686-linux-android x86_64-linux-android"}

VERSION=rotd-${ROTD}
ARCHIVE=mercury-srcdist-${VERSION}.tar.gz
REPO=http://dl.mercurylang.org/rotd

INSTALL_PATH=${PREFIX}/mercury-hlc.gc-${ROTD}

if [ ! -e $ARCHIVE ]
then
wget $REPO/$ARCHIVE 
fi

for TARGET in $ABIS
do
tar -xvf $ARCHIVE
TARGDIR="${INSTALL_PATH}/root-${TARGET}"
mkdir -p $TARGDIR
cd mercury-srcdist-${VERSION}
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
if [ $TARGET = "armv7a-linux-androideabi" ]
then
export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as
export RANLIB=$TOOLCHAIN/bin/arm-linux-androideabi-ranlib
export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip
export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
else
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip
export LD=$TOOLCHAIN/bin/$TARGET-ld
fi
export CC=$TOOLCHAIN/bin/$TARGET$ANDROID_SDK-clang
export CXX=$TOOLCHAIN/bin/$TARGET$ANDROID_SDK-clang++

mercury_cv_cc_type=clang \
mercury_cv_clang_version=4.2.1 \
mercury_cv_sigaction_field=sa_handler \
mercury_cv_sigcontext_struct_2arg=no \
mercury_cv_sigcontext_struct_3arg=no \
mercury_cv_siginfo_t=no \
mercury_cv_is_bigender=no \
mercury_cv_is_littleender=yes \
mercury_cv_normal_system_retval=no \
mercury_cv_can_do_pending_io=no \
mercury_cv_gcc_labels=no \
mercury_cv_asm_labels=no \
mercury_cv_gcc_model_fast=no \
mercury_cv_gcc_model_reg=no \
mercury_cv_cannot_use_structure_assignment=yes \
C_COMPILER_TYPE="clang_$($CC -dumpversion)" \
sh ./configure  --enable-libgrades=hlc.gc --host $TARGET --with-cc=$CC --prefix $TARGDIR && 
mmake install -j3 
ln -s $MERCURYHOME/bin/* $TARGDIR/bin || true
mmake MC=$TARGDIR/bin/mmc install_library -j3  
cd ..
rm -rf mercury-srcdist-${VERSION}
done


